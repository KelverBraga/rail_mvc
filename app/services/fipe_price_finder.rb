require "csv"

class FipePriceFinder
  FIPE_CSV_PATH = Rails.root.join("db", "fipe_2022.csv")

  def initialize(model:, year:)
    @model = model.to_s.strip.downcase
    @year = year.to_i
  end

  def call
    return nil unless File.exist?(FIPE_CSV_PATH)

    separator = detect_separator
    model_col, year_col, price_col = detect_columns(separator)
    return nil unless model_col && year_col && price_col

    candidates = []

    CSV.foreach(FIPE_CSV_PATH, headers: true, col_sep: separator) do |row|
      model_value = row[model_col].to_s.downcase
      next if model_value.empty?

      next unless model_matches?(model_value)

      year_value = extract_year(row[year_col])
      next if year_value.zero?

      price = parse_price(row[price_col])
      candidates << { year: year_value, price: price } if price
    end

    return nil if candidates.empty?

    # Prioriza ano exato; se não existir, pega o ano mais próximo
    exact = candidates.find { |c| c[:year] == @year }
    return exact[:price] if exact

    closest = candidates.min_by { |c| (@year - c[:year]).abs }
    closest[:price]
  end

  private

  def detect_separator
    first_line = File.open(FIPE_CSV_PATH, &:readline)
    first_line.include?(";") ? ";" : ","
  rescue StandardError
    ","
  end

  def detect_columns(separator)
    headers = CSV.open(FIPE_CSV_PATH, "r", col_sep: separator, &:readline)
    normalized = headers.map { |h| h.to_s.strip.downcase }

    model_col = find_column(
      normalized,
      %w[modelo modelo_fipe model nome_modelo descricao descricao_modelo]
    )
    year_col = find_column(
      normalized,
      %w[ano_modelo ano year ano_model year_model year_of_reference]
    )
    price_col = find_column(
      normalized,
      %w[valor preco price valor_medio valor_médio valor_veiculo avg_price_brl avg_price]
    )

    [headers[model_col], headers[year_col], headers[price_col]] if model_col && year_col && price_col
  rescue StandardError
    [nil, nil, nil]
  end

  def find_column(normalized_headers, candidates)
    candidates.each do |candidate|
      idx = normalized_headers.index(candidate)
      return idx if idx
    end
    nil
  end

  def model_matches?(csv_model)
    csv_model.include?(@model) || @model.include?(csv_model)
  end

  def extract_year(raw)
    raw.to_s[/\d{4}/].to_i
  end

  def parse_price(raw)
    str = raw.to_s
    digits = str.gsub(/[^\d,\.]/, "")
    return nil if digits.empty?

    normalized =
      if digits.count(",") == 1 && digits.count(".") >= 1
        digits.gsub(".", "").gsub(",", ".")
      elsif digits.count(",") == 1 && digits.count(".") == 0
        digits.tr(",", ".")
      else
        digits
      end

    Float(normalized)
  rescue StandardError
    nil
  end
end


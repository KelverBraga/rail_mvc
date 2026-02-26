require "csv"

class FipePriceHistory
  FIPE_CSV_PATH = Rails.root.join("db", "fipe_2022.csv")

  def initialize(model:)
    @model = model.to_s.strip.downcase
  end

  def call
    return [] unless File.exist?(FIPE_CSV_PATH)

    separator = detect_separator
    headers = CSV.open(FIPE_CSV_PATH, "r", col_sep: separator, &:readline)
    normalized = headers.map { |h| h.to_s.strip.downcase }

    brand_col = normalized.index("brand")
    model_col = normalized.index("model")
    year_model_col = normalized.index("year_model")
    price_col = normalized.index("avg_price_brl") || normalized.index("avg_price")

    return [] unless model_col && year_model_col && price_col

    rows = []

    CSV.foreach(FIPE_CSV_PATH, headers: true, col_sep: separator) do |row|
      csv_model = row[model_col].to_s.downcase
      next if csv_model.empty?
      next unless csv_model.include?(@model) || @model.include?(csv_model)

      year_model = row[year_model_col].to_i
      price = row[price_col].to_f
      next if year_model.zero? || price.zero?

      rows << { year_model: year_model, avg_price_brl: price }
    end

    rows.sort_by { |r| r[:year_model] }
  rescue StandardError
    []
  end

  private

  def detect_separator
    first_line = File.open(FIPE_CSV_PATH, &:readline)
    first_line.include?(";") ? ";" : ","
  rescue StandardError
    ","
  end
end


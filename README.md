---

# Car Sales Rails Application

A Ruby on Rails application for managing car listings.
This project allows users to register vehicles and filter cars that are available for sale.

## Overview

The system follows the MVC (Model-View-Controller) architecture and uses ActiveRecord for database management. It demonstrates basic CRUD structure and filtering records from the database.

## Features

* Create car records
* Store vehicle information:

  * Model
  * Year
  * Color
  * Electric (boolean)
  * Is Selling (boolean)
* List all registered cars
* Display only cars available for sale

## Technologies Used

* Ruby
* Ruby on Rails 8
* SQLite3
* ActiveRecord
* MVC Architecture

## Database Structure

The `cars` table contains the following fields:

| Column     | Type     |
| ---------- | -------- |
| id         | integer  |
| model      | string   |
| year       | integer  |
| color      | string   |
| electric   | boolean  |
| is_selling | boolean  |
| created_at | datetime |
| updated_at | datetime |

## Installation and Setup

Clone the repository:

```bash
git clone https://github.com/your-username/your-repository.git
cd your-repository
```

Install dependencies:

```bash
bundle install
```

Run database migrations:

```bash
rails db:migrate
```

Start the server:

```bash
rails server
```

Open your browser and access:

```
http://localhost:3000
```

## Example Query (Cars Available for Sale)

Controller:

```ruby
@available_cars = Car.where(is_selling: true)
```

View:

```erb
<% @available_cars.each do |car| %>
  <p><%= car.model %></p>
<% end %>
```

## Purpose

This project was developed to practice:

* Rails MVC structure
* Database migrations
* ActiveRecord queries
* Filtering data
* Git and GitHub workflow

## Author

Kelver Ruan Braga
Automation Engineer | Ruby on Rails Developer

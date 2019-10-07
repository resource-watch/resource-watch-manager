# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Dashboard.create!(
  name: 'Test dashboard one',
  description: 'test dashboard one description',
  content: 'test dashboard one description',
  published: true,
  summary: 'test dashboard one summary',
  user_id: '1a10d7c6e0a37126611fd7a5',
  private: true,
  production: true,
  preproduction: false,
  staging: false
)

Dashboard.create!(
  name: 'Test dashboard two',
  description: 'test dashboard two description',
  content: 'test dashboard two description',
  published: true,
  summary: 'test dashboard two summary',
  user_id: '1a10d7c6e0a37126611fd7a6',
  private: true,
  production: true,
  preproduction: false,
  staging: false
)

Dashboard.create!(
  name: 'Test dashboard three',
  description: 'test dashboard three description',
  content: 'test dashboard three description',
  published: true,
  summary: 'test dashboard three summary',
  user_id: '1a10d7c6e0a37126611fd7a7',
  private: true,
  production: true,
  preproduction: false,
  staging: false
)

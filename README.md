# ☕ EspressoDialer

EspressoDialer is a Ruby on Rails application designed to track and perfect MY espresso dialing process. It manages my Beans, Baskets, Recipes, and individual Brews. I got tired of formatting my notes and rewriting my brews when only a single decimal had to be changed. That motivated me to create this web app. 

## Features & Architecture
The application utilizes a unique dual-database architecture to safely allow public guests to test the app without corrupting private data.
*   **Admin Mode:** Uses a permanent PostgreSQL database. Accessed via a secure password.
*   **Sandbox Mode:** Uses a secondary PostgreSQL database populated with temporary seed data.

## Environment Variables
To deploy or run this application in production I configured the following environment variables:
*   `ADMIN_PASSWORD`: The password required to unlock Admin Mode.
*   `ADMIN_DATABASE_URL`: Connection string for the permanent Admin PostgreSQL database (in my case Neon).
*   `SANDBOX_DATABASE_URL`: Connection string for the Sandbox PostgreSQL database.
*   `RAILS_MASTER_KEY`: My master key for encrypted credentials.

## Local Setup
To get the project running on your local machine quickly, follow these steps:
1. Clone the repository and run `bundle install` to install Ruby dependencies.
2. Run `rails db:setup` to create the local databases and apply the schema.
3. Load the default mock data by running `rails db:seed`.
4. Start the local development server using `bin/dev`.

## Useful Shortcuts & Commands
Here are the quickest ways to manage your data without manual entry or database manipulation:

*   **Reset the Sandbox:** Run the following in your console to automatically wipe the guest database and immediately reload your `db/seeds.rb` file:
    ```bash
    rails sandbox:reset
    ```

*   **Trigger Render Setup:** Execute the following to compile assets, run migrations across both Postgres databases, and conditionally seed the Sandbox:
    ```bash
    ./bin/render-setup.sh
    ```

*   **Complete Local Reset:** Run this to completely nuke and rebuild your local development environment from scratch:
    ```bash
    rails db:drop db:create db:migrate db:seed
    ```
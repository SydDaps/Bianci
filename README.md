# Bianchi
A DSL (Domain-Specific Language) and a minimalist framework in Ruby, tailored for USSD development. Structured around a menu page approach, Bianchi offers a comprehensive suite of methods and generators, streamlining the process of building USSD applications efficiently and easily.

## Installation
Add `gem 'bianchi', '~> 0.1.0'` to your gem file and run `bundle install`

## Getting Started

To initialize a new USSD project, generate a project directory using Bianchi's command-line interface. Use the following Ruby command:

```ruby
bundle exec bianchi setup -p provider_name
```

Replace `provider_name` with your desired provider. Currently supported providers include: africa_is_talking.

This command creates a `ussd/engine.rb` file in the project root directory. Here's a sample content of `ussd/engine.rb`:

```ruby
module USSD
  class Engine
    def self.start(params)
      Bianchi::USSD::Engine.start(params, provider: :africa_is_talking) do
        # e.g menu :main, options
      end
    end
  end
end
```

To define menus for your USSD applications' engine instance, use the following command:

```ruby
menu :menu_name, options
```

For example, let's define our first menu, which serves as the initial menu of the application, and let's call this the main menu:

```ruby
menu :main, initial: true
```
now that we have the initial menu up let's generate our pages for that menu using Bianchi's command-line interface. Use the following Ruby command:
```ruby
command: bundle exec bianchi g menu menu_name page page_number
example: bianchi g menu main page 1
```
This creates a `ussd/main_menu/page_1` file in the project root directory. Here's a sample content of the file:

```ruby
module USSD
  module MainMenu
    class Page1 < Bianchi::USSD::Page
      def request
      end

      def response
      end
    end
  end
end
```

In the `ussd/main_menu/page_1` file, the main application code goes into the `request` and `response` methods. Here's a sample code to illustrate the usage:

```ruby
module USSD
  module MainMenu
    class Page1 < Bianchi::USSD::Page
      def request
        render_and_await(request_body)
      end

      def response
        case session_input_body
        when "1"
          redirect_to_greet_menu_page_1
        when "2"
          redirect_to_repeat_menu_page_1
        else
          render_and_await("invalid input \n" + request_body)
        end
      end

      private

      def request_body
        <<~MSG
          Welcome
          1. Greetings
          2. Repeat my name
        MSG
      end
    end
  end
end
```

In this example, when a page is requested, you send some information, and the end user submits data for that request. The `response` method processes the response data and can move to a new page request, end the session, or send a response from there.
### Page Renders

In Bianchi USSD applications, any method that starts with `render` sends data back to the user. Typically, we either send data and expect a response or send data and terminate the session. Here are the two main methods for rendering pages:

- `render_and_await(string)`: Responds to the user and expects the user to respond.

- `render_and_end(string)`: Responds to the user and terminates the session.

Here's how you can use these methods in Ruby:
```ruby
render_and_await("Please select an option:")
```
This method sends the message "Please select an option:" to the user and awaits their response.
```ruby
render_and_end("Thank you for using our service. Goodbye!")
```
This method sends the message "Thank you for using our service. Goodbye!" to the user and terminates the session.

### Page Session

In Bianchi USSD applications, the `session` serves as an information tracker between all the pages and records all interactions between the user and the application. It contains valuable information necessary for the USSD application to function properly.

Here are the methods available within the page session:

- `session_params`: Returns a hash containing all the data the provider sent.
- `session_input_body`: Retrieves the user's current input.
- `session_mobile_number`: Returns the current user's phone number dialing the code.
- `session_session_id`: Provides the session's ID.
- `session.store`: Accesses the current session's cache. Further details about this will be discussed later.

### Page Store

In Bianchi USSD applications, the `session.store` serves as the main application cache, where data can be stored and accessed across all pages.

Here are the methods available within the page store:

- `session.store.set(key, value)`: Stores a key-value pair in the cache.
- `session.store.get(key)`: Retrieves the value associated with a given key from the cache.
- `session.store.all`: Returns the entire cache as a hash.

Here's how you can use these methods to manage your application's cache:

```ruby
# Storing data in the cache
session.store.set('user_id', 123)

# Retrieving data from the cache
user_id = session.store.get('user_id')

# Retrieving the entire cache
all_data = session.store.all
```

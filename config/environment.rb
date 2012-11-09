# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Theroot::Application.initialize!

Haml::Template.options[:ugly] = true
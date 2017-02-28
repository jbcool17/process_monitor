#config.ru
require 'json'
require_relative './lib/app'

# Serve requests to assets in /images, /js and /css with public/images, public/js and public/css.
use Rack::Static,
  :urls => ["/images", "/js", "/css"],
  :root => 'public'

run App.new

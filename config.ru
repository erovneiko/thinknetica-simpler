require_relative 'lib/middleware/logger'
require_relative 'config/environment'

use Logger
run Simpler.application

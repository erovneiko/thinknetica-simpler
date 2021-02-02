# require_relative 'lib/middleware/logger'
require_relative 'lib/middleware/app_logger'
require_relative 'config/environment'

# use Logger
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application

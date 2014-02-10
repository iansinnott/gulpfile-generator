#!/usr/bin/env ruby
require 'json'

# Add colorization to strings
# See: http://stackoverflow.com/questions/1489183/colorized-ruby-output
class String

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def bold; "\033[1m#{self}\033[22m" end

  def red;     colorize(31) end
  def green;   colorize(32) end
  def yellow;  colorize(33) end
  def blue;    colorize(34) end
  def purple;  colorize(35) end
  def cyan;    colorize(36) end
  def gray;    colorize(37) end

end

# All node modules to be instaleld
@npm_install = []
@npm_install << 'gulp'              # Needs no intro
@npm_install << 'gulp-util'         # Useful utils
@npm_install << 'gulp-sass'         # The main event
@npm_install << 'gulp-autoprefixer' # Prefixer
@npm_install << 'gulp-minify-css'   # CSS minification
@npm_install << 'gulp-rename'       # Rename files
@npm_install << 'gulp-livereload'   # Livereload
@npm_install << 'tiny-lr'           # Livereload server

# Ininstall everything that this script creates.
def implode
  uninstall = @npm_install.unshift('npm uninstall --save-dev')
  begin
    system uninstall.join(' ')
  rescue Exception => e
    exit_with_error e
  end

  File.delete('gulpfile.js') if File.exists?('gulpfile.js')
end

# Handle unknown params
if !ARGV.empty?
  unless ARGV.first == 'implode'
    puts "Sorry, that's not a valid command."
    puts "Either enter the 'implode' command or no command at all."
    exit
  end

  implode
  exit
end

# First of all, see if the file already exists:
if File.exists?('gulpfile.js')

  puts "You already gave a " << 'gulpfile.js'.yellow << '.'
  print "It will be overwritten if you continue. Are you sure? (y/N) "
  confirm = gets.chomp

  unless confirm.upcase == 'Y'
    puts 'Exiting...'
    exit
  end

  puts # Create a new line and continue.

end

def exit_with_error(error)
  puts 'Uh oh, there was an error: ' << error.message.red
  puts 'Exiting...'
  exit
end

# The contents of the generated gulpfile
@gulpfile = <<-GULPFILE
var gulp = require('gulp'),
  gutil = require('gulp-util'),
  sass = require('gulp-sass'),
  autoprefixer = require('gulp-autoprefixer'),
  minifycss = require('gulp-minify-css'),
  rename = require('gulp-rename'),
  livereload = require('gulp-livereload'),
  lr = require('tiny-lr'),
  server = lr()

// SCSS compilation and relaod
gulp.task('sass', function() {
  return gulp.src('sass/style.scss')
    .pipe(sass())
    .pipe(autoprefixer( 'last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4' ))
    .pipe(gulp.dest('css'))
    .pipe(livereload(server))
})

gulp.task('watch', function() {
  server.listen(35729, function(err) {
    if (err)
      return console.log(err)
    gulp.watch('sass/**/*.scss', ['sass'])
  })
});
GULPFILE

# Create a package.json file for npm. This will be added to when we call
# the npm install commands with the --save-dev flag. If it ddoesn’t exist
# it must be created.
def create_package_file
  puts 'No ' << 'package.json'.green << ' file found. Generating...'
  puts

  default_project_name = File.basename(Dir.pwd)
  default_project_version = '0.0.1'

  print "Project Name (#{default_project_name}): "
  project_name = gets.chomp
  project_name = project_name.empty? ? default_project_name : project_name

  print "Project Version (#{default_project_version}): "
  version = gets.chomp
  version = version.empty? ? default_project_version : version

  package = { name: project_name, version: version }

  begin
    File.open('package.json', 'w') do |file|
      file.write package.to_json
    end
  rescue Exception => e
    exit_with_error e
  end

  puts 'package.json'.green << ' successfully created.'
end

# Install the npm packages through the system command.
# Note: this does not check to see if npm was successful.
def install_packages
  install = @npm_install.unshift('npm install --save-dev')
  begin
    system install.join(' ')
  rescue Exception => e
    exit_with_error e
  end
end

# Simply write the contents of the gulpfile defined at the top to
# gulpfile.js in the current directory.
def write_gulpfile
  begin
    File.open('gulpfile.js', 'w') do |file|
      file.write @gulpfile
    end
  rescue Exception => e
    exit_with_error e
  end

  puts
  puts "Complete:".green << " Unless there were npm errors above, you're good to go!"
  puts
  puts "Use the following commands: "
  puts 
  puts "    gulp sass".green.bold << "  # To compile immediately".gray
  puts "    gulp watch".green.bold << " # To watch the ./sass directory".gray
  puts
end

unless File.exists?('package.json')
  create_package_file
end
install_packages
write_gulpfile

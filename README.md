Ruby-Scripts
============

This contains two ruby scripts. One is a css file analyzer, and other is a appache server log file analyzer. 

css-colors.rb

run the script on terminal like >
  $ruby css-colors <path_to_css_file || link_to_hosted_css_resouce>
  
  running the script will hive you a report.html file in the same directory which will give you a visual of all 
  the colors used in the css along with the number of times each has been used. 

log-stats.rb 
  run the script along with its options and a path to the appache log file.
  $ruby css-colors <path_appache_log_file || link_to_hosted_apache_log> --<options>
  
  options can be --hourly -> to get a count of resouces on hourly basis 
                 --requesters -> to get a count on requesters ip basis 
                 --error ->  to get a count on http error types
                 --resources -> to get a count on the basis of resource requested
                 --help -> list the available options
                 
                 
                 
                 
                 
                 
                 

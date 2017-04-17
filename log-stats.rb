# log-stats.rb 
#   run the script along with its options and a path to the appache log file.
#   $ruby css-colors < path_appache_log_file OR link_to_hosted_apache_log> --< options >
  
#   options can be --hourly -> to get a count of resouces on hourly basis 
#                  --requesters -> to get a count on requesters ip basis 
#                  --error ->  to get a count on http error types
#                  --resources -> to get a count on the basis of resource requested
#                  --help -> list the available options





require 'getoptlong'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],[ '--resources', GetoptLong::REQUIRED_ARGUMENT ],[ '--errors', GetoptLong::REQUIRED_ARGUMENT ], [ '--requesters', GetoptLong::REQUIRED_ARGUMENT ], [ '--hourly', GetoptLong::REQUIRED_ARGUMENT ])



opts.each do |opt, arg|

 case opt
  when '--help'
     puts %Q{   Usage:::\n --resources to see the resources requested count\n--errors to see errors.\n--requesters to see requesters by i.p\n--hourly to see requests per hour count }
  when '--resources' 
    scan_and_print_results(arg , opt)    
  when '--requesters'
   scan_and_print_results(arg , opt)
  when '--errors'
   scan_and_print_results(arg , opt)
  when '--hourly'
   scan_and_print_results(arg , opt)
end
end




BEGIN {
    def scan_and_print_results(arg , opt)
     if File.exists?(arg)
        file_path = arg
        counts = scan_log( file_path, opt) 
        counts.sort_by { |x, y| (opt == '--hourly')?  x : [ -Integer(y), x ] }.each do |k,v|
         puts "#{v}    #{k}" 
        end
	else
	puts "Passed argument is not a valid file"
    end
    
    end
    
    
def scan_log(file_path, type)
 f = File.open(file_path)
 case type 
  when '--requesters'
   match_str = /\b(?:\d{1,3}\.){3}\d{1,3}\b/
  when '--resources' 
   match_str = /"(.*?)"/
  when '--errors'
   match_str = /\s[4,5][\d][\d]\s[-,\d]/
  when '--hourly'
   match_str = /\[.*\]/
 
 end 
  counts = {}
  f.each_line do |line|
    line.scan(match_str) do |word|
    word = word.first if word.class == Array
     word = word.split(' ').at(1) if type == '--resources'
     word = word.split(' ').first if type == '--errors'
     word = word.split(' ').first.split(':').at(1) if type == '--hourly'
     if counts.has_key?(word)
      counts[word] += 1
     else
      counts[word] = 1  
     end
    end
  end
  counts
 
 end

}






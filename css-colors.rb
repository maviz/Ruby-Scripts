# css-colors.rb
# _____________
# run the script on terminal like >
#   $ruby css-colors < path_to_css_file OR url_to_hosted_css_resouce >
  
#   running the script will give you a report.html file in the same directory which will give you a visual of all 
#   the colors used in the css along with the number of times each has been used. 


require 'net/http'
unless ARGV[0] == nil || ARGV[1] == nil                             #  checking for arguments if they are passed along or not ?
 if File.exists?(ARGV[0]) && !ARGV[0].scan(/.css/).empty?           # enters this block if passed argument is a file that to a .css one
  arr = []
  f = File.open(ARGV[0],'r')
  f.each_line do |line|
    arr << line.scan(/(?<=#)(?<!^)(\h{6}|\h{3})/)
  end
  arr.flatten!                                      # opened the file for reading and line by line mached for hexadecimal color patterns and inserted the hex codes in array if found
  parse_html(arr)                                  # pass the array to html_parser function
 
 elsif !ARGV[0].scan(/http:\/\//).empty?                               # enter this block if passed argument is a url 
 
 uri = ARGV[0]  
 url = URI.parse(uri)
 req = Net::HTTP::Get.new(url.to_s)
 res = Net::HTTP.start(url.host, url.port) {|http|
   http.request(req)
 }                                                              # send http request to the url to get back the response
 
 arr = res.body.scan(/(?<=#)(?<!^)(\h{6}|\h{3})/).flatten!      # inserted the hex codes from the response body in the array 

 unless arr.length == 0                                         # if some codes were found, pass the array to html_parser function
  parse_html(arr, url)
 else
  puts "The response wasn't css or contained no Hex colors" 
 end

else
 puts 'Arguments error'
end

else
puts 'Requires exactly two arguments.'

end


    






BEGIN {    
    def parse_html(arr, url = nil )               # this is the html_parser function, it takes an array and a string url as arguments, considers url nil if local file path was passed
    
     # this is a string variable with static part the report html ( boiler plate )
    html_string = %Q{ <!DOCTYPE html>      
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>Stylesheet Colors</title>
    <style>
      body {
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        color: #333;
      }
      h1 {
        font-size: 40px;
        font-weight: 300;
        margin: 36px 8px 8px 8px;
        color: #333;
      }
      h2 {
        margin: 0 8px 20px 8px;
        font-size: 18px;
        font-weight: 300;
      }
      h2 a {
        color: #999 !important;
        text-decoration: none;
      }
      h2 a:hover {
        text-decoration: underline;
      }
      .color { 
        height: 200px;
        width: 200px;
        float: left;
        margin: 10px;
        border: 1px solid #000; 
        position: relative;
        -webkit-box-shadow: 0 0 10px #eee; 
        -moz-box-shadow: 0 0 10px #eee; 
        box-shadow: 0 0 10px #eee; 
      }
      .color:hover {
        -webkit-box-shadow: 0 0 10px #666; 
        -moz-box-shadow: 0 0 10px #666; 
        box-shadow: 0 0 10px #666; 
      }
      .info { 
        background-color: #fff;
        background-color: rgba(255,255,255,.5);
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        padding: 5px;
        border-top: 1px solid #000;
        font-size: 12px;
        text-align: right;
      }
      .rgb {
        float: left;
      }
    </style>
  </head>
  <body>
    <h1>Stylesheet Colors</h1>
       }
    html_string += %Q{ <h2><a href="#{url}">#{url}</a></h2> } unless url.nil?   # add a link if url was passed
    
    
    f = File.new("#{ARGV[1]}.html","w+")                   # open report.html file for writing
    color_count = {}                                   # init color hash that will save the color specific html div code and number of repetions for each color 
  arr.each do |color| 
    if color.length == 3                                       # convert 3 digit short hex to 6 digit
        color = "#{color[0]*2}#{color[1]*2}#{color[2]*2}"
    end  
    if color_count.has_key?(color)                               # check if color if being repeated, if so, just increment the counter value stored by 'q' key in the colors hash
     color_count[color]['q'] += 1
    else                                                      # if the color is having its first turn, add its value in the hash with the repition counter and color html div
    color_count[color] = {}
     color_count[color]['q'] = 1
     # adding color specific div in the colors hash
     color_count[color]['html'] = %Q{ <div class="color" style="background-color: ##{color}">   
  <div class="info">
    <div class="rgb">
      RGB: #{color[0..1].hex}, #{color[2..3].hex}, #{color[4..5].hex}
    </div>
    <div class="hex">
      Hex: ##{color}
    </div>
  </div>
</div>  } 
    end
 end
   
  color_count.sort_by {|k,v| v['q'] }.reverse.each do |k,v|     # sort the color_count hash against the repetion counter to append each colors div to the html_string 
    html_string +=  v['html']
    end
  
  
  html_string += %Q{</body></html>}               # ending tags for html_string that will now be written onto the report.html file we opened earlier                                                     

   f.print(html_string)                         # parse the html file
   f.close
    end
    
    }




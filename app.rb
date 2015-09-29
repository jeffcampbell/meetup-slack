# encoding: utf-8
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

configure do
  # Load .env vars
  Dotenv.load
  # Disable output buffering
  $stdout.sync = true
end

get "/" do
  ""
end

post "/" do
  response = ""

  unless params[:token] != ENV["OUTGOING_WEBHOOK_TOKEN"]
    response = { text: "Next Meetup:" }
    response[:attachments] = [ generate_attachment ]
    response[:username] = ENV["BOT_USERNAME"] unless ENV["BOT_USERNAME"].nil?
    response[:icon_emoji] = ENV["BOT_ICON"] unless ENV["BOT_ICON"].nil?
    response = response.to_json
  end

  status 200
  body response
end

def generate_attachment
  uri = "https://api.meetup.com/2/events?group_urlname=#{ENV["MEETUP_GROUP_URL"]}&page=1&key=#{ENV["MEETUP_API_KEY"]}"
  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"

  # Check for a nil response in the array
  @results = JSON.parse(request.body)["results"][0]
  if @results.nil?
    response = { title: "No upcoming Meetups" }
  else

  # Check for venue information
  if @results["venue"]
    @name = @results["venue"]["name"]
    @lat = @results["venue"]["lat"]
    @lon = @results["venue"]["lon"]
    location = "<http://www.google.com/maps/place/#{@lat},#{@lon}|#{@name}>"
  else
    location = "No location provided"
  end

  get_name = @results["name"]

  get_url = @results["event_url"]

  raw_time = @results["time"].to_f / 1000
  utc_offset = @results["utc_offset"].to_i / 1000
  calc_time = Time.at(raw_time).getlocal(utc_offset)
  cldr_time = calc_time.localize
  get_time = "#{cldr_time.to_short_s} #{cldr_time.to_date.to_full_s}"

  response = { title: "#{get_name}", title_link: "#{get_url}", text: "#{get_time}\n#{location}", color: "#{ENV["COLOR"]}"}

  end

end

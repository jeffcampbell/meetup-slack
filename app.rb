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
  uri = "https://api.meetup.com/2/events?group_id=#{ENV["MEETUP_GROUP_ID"]}&page=2&key=#{ENV["MEETUP_API_KEY"]}"
  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"

  # Check for a nil response in the array
  @firstresults = JSON.parse(request.body)["results"][0]
  @secondresults = JSON.parse(request.body)["results"][1]

  # First Meetup
  if @firstresults.nil?
    response = { title: "No upcoming Meetups" }
  else
  # Check for venue information
  if @firstresults["venue"]
    @name = @firstresults["venue"]["name"]
    @lat = @firstresults["venue"]["lat"]
    @lon = @firstresults["venue"]["lon"]
    firstlocation = "<http://www.google.com/maps/place/#{@lat},#{@lon}|#{@name}>"
  else
    firstlocation = "No location provided"
  end
  get_firstname = @firstresults["name"]
  get_firsturl = @firstresults["event_url"]
  raw_firsttime = @firstresults["time"].to_f / 1000
  utc_firstoffset = @firstresults["utc_offset"].to_i / 1000
  calc_firsttime = Time.at(raw_firsttime).getlocal(utc_firstoffset)
  cldr_firsttime = calc_firsttime.localize
  get_firsttime = "#{cldr_time.to_short_s} #{cldr_time.to_date.to_full_s}"
  end

  # Second Meetup
  if @secondresults.nil?
    get_secondname = ""
    get_secondurl = ""
    get_secondtime = ""
    secondlocation = ""
  else
  # Check for venue information
  if @secondresults["venue"]
    @name = @secondresults["venue"]["name"]
    @lat = @secondresults["venue"]["lat"]
    @lon = @secondresults["venue"]["lon"]
    secondlocation = "<http://www.google.com/maps/place/#{@lat},#{@lon}|#{@name}>"
  else
    secondlocation = "No location provided"
  end
  get_secondname = @secondresults["name"]
  get_secondurl = @secondresults["event_url"]
  raw_secondtime = @secondresults["time"].to_f / 1000
  utc_secondoffset = @secondresults["utc_offset"].to_i / 1000
  calc_secondtime = Time.at(raw_secondtime).getlocal(utc_secondoffset)
  cldr_secondtime = calc_secondtime.localize
  get_secondtime = "#{cldr_time.to_short_s} #{cldr_time.to_date.to_full_s}"

  response = { title: "#{get_firstname}", title_link: "#{get_firsturl}", text: "#{get_firstime}\n#{firstlocation}", color: "#{ENV["COLOR"]}"}
  end

end

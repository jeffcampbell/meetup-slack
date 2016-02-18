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
begin
  puts "[LOG] #{params}"
  params[:text] = params[:text].sub(params[:trigger_word], "").strip.gsub(/:/, '')
  unless params[:token] != ENV["OUTGOING_WEBHOOK_TOKEN"]
    response = { text: "Next Meetup:" }
    response[:attachments] = [ generate_attachment ]
    response[:username] = ENV["BOT_USERNAME"] unless ENV["BOT_USERNAME"].nil?
    response[:icon_emoji] = ENV["BOT_ICON"] unless ENV["BOT_ICON"].nil?
    response = response.to_json
  end
end
  status 200
  body response
end

def generate_attachment
  @user_query = params[:text]
if @user_query.length == 0
  uri = "https://api.meetup.com/2/events?group_id=#{ENV["MEETUP_GROUP_ID"]}&page=2&key=#{ENV["MEETUP_API_KEY"]}"
else
  uri = "https://api.meetup.com/2/open_events?topic=#{@user_query}&zip=#{ENV["ZIP_CODE"]}&page=2&key=#{ENV["MEETUP_API_KEY"]}"
end
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
  get_firstrsvpcount = @firstresults["yes_rsvp_count"]
  get_firstwaitlistcount = @firstresults["waitlist_count"]
  raw_firsttime = @firstresults["time"].to_f / 1000
  utc_firstoffset = @firstresults["utc_offset"].to_i / 1000
  calc_firsttime = raw_firsttime + utc_firstoffset
  final_firsttime = Time.at(calc_firsttime)
  cldr_firsttime = final_firsttime.localize
  get_firsttime = "#{cldr_firsttime.to_short_s} #{cldr_firsttime.to_date.to_full_s}"
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
  calc_secondtime = raw_secondtime + utc_secondoffset
  final_secondtime = Time.at(calc_secondtime)
  cldr_secondtime = final_secondtime.localize
  get_secondtime = "#{cldr_secondtime.to_short_s} #{cldr_secondtime.to_date.to_full_s}"

  def generate_asteroid
    asteroid_time = Time.at(calc_firsttime).strftime "%Y-%m-%d"
    puts "[LOG] #{asteroid_time}"

    asteroid = ""
    nasauri = "https://api.nasa.gov/neo/rest/v1/feed?start_date=#{asteroid_time}&api_key=#{ENV["NASA_API_KEY"]}"
    request = HTTParty.get(nasauri)
    puts "[LOG] #{request.body}"
    asteroid = JSON.parse(request.body)

    asteroiddata = asteroid["near_earth_objects"]["#{asteroid_rawtime}"][0]

    asteroid_url = asteroiddata["nasa_jpl_url"]
    asteroid_name = asteroiddata["name"]
    asteroid_approach = asteroiddata["close_approach_data"][0]["miss_distance"]["astronomical"].round(3)

    asteroid = "<#{asteroid_url}|#{asteroid_name}> - #{asteroid_approach}>"
end

  response = { title: "#{get_firstname}", title_link: "#{get_firsturl}", text: "#{get_firsttime}\n#{firstlocation}\n#{generate_asteroid}", fields: [ { title: "RSVPs", value: "#{get_firstrsvpcount}", short: true }, { title: "Waitlist", value: "#{get_firstwaitlistcount}", short: true }, { title: "Following Meetup:", value: "<#{get_secondurl}|#{get_secondname}> - #{get_secondtime}", short: false } ] }
  end

end

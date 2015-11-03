# meetup-slack
Retrieves the next upcoming Meetup and posts it to Slack, or search for Meetups in your area by topic.

![example image 1](https://cloud.githubusercontent.com/assets/4997935/10620931/ae868b54-774b-11e5-9855-c725c643fecb.png)

![example image 2](https://cloud.githubusercontent.com/assets/4997935/10620937/b2d5c6c0-774b-11e5-8a5c-f208373c3e6a.png)

### What you will need
* A [Heroku](http://www.heroku.com) account
* Your [Meetup API key](http://www.meetup.com/meetup_api/)
* An [outgoing webhook token](https://api.slack.com/outgoing-webhooks) for your Slack team
* The Group IDs for the Meetup groups you would like to use. To find a group ID navigate to the [2/groups endpoint console](https://secure.meetup.com/meetup_api/console/?path=/2/groups), enter the group url name, and retrieve the ```id``` value from the response. Ex: The NY Tech Meetup has a group url name of ```ny-tech``` and group id ```176399```.

### Setup
* Clone this repo locally
* Create a new Heroku app and initialize the repo
* Push the repo to Heroku
* Navigate to the settings page of the Heroku app and add the following config variables:
  * ```OUTGOING_WEBHOOK_TOKEN``` The token for your outgoing webhook integration in Slack
  * ```BOT_USERNAME``` The name the bot will use when posting to Slack
  * ```BOT_ICON``` The emoji icon for the bot
  * ```COLOR``` Can be any hex color code or ```good```, ```warning```, ```danger```
  * ```MEETUP_API_KEY``` The Meetup API key for your Meetup account
  * ```MEETUP_GROUP_ID``` The ID of the Meetup group or groups, seperated by comma
* Navigate to the integrations page for your Slack team. Create an outgoing webhook, choose a trigger word (ex: ".meetup"), use the URL for your heroku app, and copy the webhook token to your ```OUTGOING_WEBHOOK_TOKEN``` config variable.

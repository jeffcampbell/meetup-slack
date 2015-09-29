# meetup-slack
Retrieves the next upcoming Meetup group and posts it to Slack

![example image](http://i.imgur.com/F6hG96F.png)

### What you will need
* A [Heroku](http://www.heroku.com) account
* Your [Meetup API key](http://www.meetup.com/meetup_api/)
* An [outgoing webhook token](https://api.slack.com/outgoing-webhooks) for your Slack team

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
  * ```MEETUP_GROUP_URL``` The url of the Meetup group.
  Ex: if the url is ```http://www.meetup.com/meetup-group``` you would use ```meetup-group```
* Navigate to the integrations page for your Slack team. Create an outgoing webhook, choose a trigger word (ex: ".meetup"), use the URL for your heroku app, and copy the webhook token to your ```OUTGOING_WEBHOOK_TOKEN``` confiig variable.

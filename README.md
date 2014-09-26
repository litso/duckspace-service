Hackday Schedule
================

* 9.30am - Doors open
* 9.30 - 10.15am - Breakfast (provided)
* 10.15 - 10.30am - Welcome and info about day
* 10.30 - 11.15am - Natasha talk
* 11.15 - 11.45am - Nick talk
* 11.45 – 12.00pm - GitHub presentation talk
* 12.00 - 12:15pm - Info on hackathon, prizes, group formations etc
* 12.15 - 1.30pm - Hackathon coding start
* 1:30 - 2:30pm – Lunch (provided)
* 2:00 - 6:30pm - Hackathon coding continues
* 6.30 - 7.15pm - Dinner & Drinks (provided)
* 7.15 - 8.00pm - Last minute coding rush!
* 8.00 - 9.45pm - Presentations and winner announcements
* 9.45 - 10.00pm - Wrap-up!

duckspace-service
=================

Set up dev

    $ bundle

Local boot

    $ rerun puma
    browse to: http://localhost:9292

Local console

    $ racksh

Set up heroku

    $ heroku git:remote -a duckspace
    $ heroku addons:add cleardb:ignite

Push develop to heroku

    $ git push heroku develop:master

Push master to heroku

    $ git push heroku master

API

    /locations
    /location/1

    /posts
    /posts?location_id=1
    /posts?user_id=1
    /post/1

    /users
    /user/1

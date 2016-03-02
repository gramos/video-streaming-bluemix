Bluemix and video streaming
===========================

The idea of this article is trying to deploy an app in Bluemix
to stream videos, looking at the Bluemix services page I found
the ustream services where you can get a free account to publish
up to 10GB of videos.

https://console.ng.bluemix.net/catalog/services/ustream/

I downloaded and installed the cf client, then created a Bluemix account
and login against the bluemix cf api. Like the  documentation says I created
the ustream service and then and I bound it to our ruby example app
that I named video-demo.

1- Make an http reuqest saying that you want to upload a new video:

```POST https://api.ustream.tv/channels/CHANNEL_ID/uploads.json?type=videoupload-ftp (format can be json or xml)```

in the response to that request we will get the data to upload the video via FTP

2- Upload the video via ftp.

3- Make a request to say that file is in place.

```PUT Uhttps://api.ustream.tv/channels/CHANNEL_ID/uploads/VIDEO_ID.json (format can be json or xml)```

you can read the docs here: https://ibmcloud.ustream.tv/dashboard/api#APIFeaturesUploadVideos


Install and run the app
=======================


Clone the repo
--------------

    git clone git@github.com:gramos/video-streaming-bluemix.git

Install gems
------------

    bundle install

Generate the env file
----------------------

    cp env.example.sh env.sh

edit env.sh and fill it with your data.


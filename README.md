Processing Jenkins Monitor
===========================

![Jenkins Monitor](Jenkins_Monitor/screenshot_jenkins_monitor.png)

Recently, I looked for a way to visualize the statuses of `important` CI build jobs. Since the Jenkins CI Server already provides 
a neat way of aggregating jobs using so-called views, plus providing a convenient REST-like JSON API, I decided to implement this 
tiny visualization application myself using the Processing framework. The goals of this application are simple: 

1. Visualize jobs by displaying the total number of builds and the current build status
2. Provide additional auditory feedback
3. Run the application anywhere and independently from the target Jenkins instance

That said, this application is `not` meant to display and watch lots of jobs, that's what your Jenkins front-end does. It is more about organizing 
your `most important` jobs using Jenkins views and then display only those jobs in `this` application. You can think of this application as 
a public display (at your office for instance) in order to provide a quick overview for developers.
 
 
Installation
=============

This application runs on Linux, MacOS and Windows. Below you can find the installation instructions for `Linux`. It will be, most probably, similar for MacOS and Windows. 
You basically just need to figure out how to install Processing under MacOS and Win. Therefore, please consult the Processing documentation.

1. mkdir -p ~/sketchbook/libraries
2. git clone this into ~/sketchbook
3. Download and unzip the [HTTP Requests Library](https://github.com/runemadsen/HTTP-Requests-for-Processing/releases/download/0.1/httprequests_processing.zip) into ~/sketchbook/libraries
4. Edit the config.json according to your needs
5. Get the latest release of https://processing.org/, fire it up, and open the Jenkins_Monitor.pde
6. Run it! (press "Play")


Stand-Alone Deployment
=======================

You may also deploy this application as a stand-alone application (no need for Processing). Therefore, you must open it (once) in Processing 
and press CTRL+E (or File --> Export Application). Follow the instructions carefully and you will end up with a new folder containing all the 
necessary files in order to run this application without opening Processing. However, you `MUST` copy the audio folder and config.json file into 
that folder before starting/shipping the application.


Configuration Semantics
========================

```
{
  "server_url": "http://localhost:8181/", # This is where you Jenkins is running
  "view": "INTEGRATION", # The view you want to visualize
  "job_replace_string": "-toolkit-lsp-csra-integration-tests-nightly", # If you have really long jobs names, you may shorten them...
  "title": "MY INTEGRATION TESTING", # The title in the lower left corner
  "title_size": 30, # Obvious I guess
  "spacing": 5, # Spacing between job bars
  "refreshrate": 30, # How often you want to refresh the visualization (in seconds, please don't DOS the Jenkins ;) )
  "sayrate": 1800 # How often do you want the application to "say" the overall build status (in seconds)
}
```

SSL Hint
=========

In case you are running your Jenkins via SSL, you might need to add your certificate to the Java keystore

http://stackoverflow.com/questions/4325263/how-to-import-a-cer-certificate-into-a-java-keystore

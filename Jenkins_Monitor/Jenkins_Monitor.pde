import http.requests.*;
import ddf.minim.*;

// Global helper vars
Minim minim;
AudioPlayer player;
JSONObject jenkins_json;
JSONObject job_info;
JSONArray jenkins_data;
String replace;
long start;
int[] build_counts;
int max_builds;
int success_builds;
int textsize = 12;
int y_offset = 50;
int text_pos_x = 20;
int x_translate;
int spacer = 10;
int y_padding = 50;

void setup() {
  // GFX Setup
  frameRate(1);
  size(displayWidth, displayHeight);
  noStroke();
  smooth();
  x_translate = width/2-200;
  
  // Timing
  start = System.currentTimeMillis() / 1000L;
  
  // Jenkins Data
  jenkins_json = getJenkinsBuildInfo();
  jenkins_data = jenkins_json.getJSONArray("jobs");
  getMaxBuildNumber();
  replace = "-toolkit-lsp-csra-integration-tests-nightly";
  
  // Audio Setup
  minim = new Minim(this);
}

JSONObject getJenkinsBuildInfo() {
  GetRequest get = new GetRequest("http://hcc:8182/view/TESTING/api/json");
  get.send();
  JSONObject response = parseJSONObject(get.getContent());
  return response;
}

JSONObject getJobInfo(String job_name) {
  GetRequest get = new GetRequest("http://hcc:8182/job/"+job_name+"/api/json");
  get.send();
  JSONObject response = parseJSONObject(get.getContent());
  return response;
}

void TTS(String Text) {
  GetRequest get = new GetRequest("http://translate.google.com/translate_tts?tl=en&q="+Text);
  get.send();
  // println(Text);
  // player = minim.loadFile(get.getContent());
  // player.play();
}

int getMaxBuildNumber() {
  build_counts = new int[jenkins_data.size()]; 
  for (int i = 0; i < jenkins_data.size(); i++) {
    JSONObject job = jenkins_data.getJSONObject(i);
    String status = job.getString("color");
    String name = job.getString("name");
    String url = job.getString("url");
    job_info = getJobInfo(name);
    int build_count = job_info.getInt("nextBuildNumber");
    build_counts[i] = build_count;     
  }
  max_builds = max(build_counts); 
  return max_builds; 
}

float computeRectLength(float builds) {
    int max = width-x_translate-y_padding;
    float factor = (builds/max_builds)*max;
    return factor;
}

void makeRect(int x, int y, float w, float h, color c) {
  fill(c);
  rect(x, y, w, h);
}

void draw() {
  background(128, 128, 128);
  long now = System.currentTimeMillis() / 1000L;
  
  if (now-start > 20) {
    jenkins_json = getJenkinsBuildInfo();
    jenkins_data = jenkins_json.getJSONArray("jobs");
    getMaxBuildNumber();
    start = System.currentTimeMillis() / 1000L;
    println("--> Refreshing <--");
  }
  
  pushMatrix();
  translate(x_translate, y_offset);
  
  success_builds = 0;
  int offset = 0;
  int number_of_jobs = jenkins_data.size();
  int rect_height = (height/2)/number_of_jobs;
  
  for (int i = 0; i < jenkins_data.size(); i++) {
    JSONObject job = jenkins_data.getJSONObject(i);
    String status = job.getString("color");
    String name = job.getString("name");
    String url = job.getString("url");
    
    color c;
    
    job_info = getJobInfo(name);
    float build_count = (float)job_info.getInt("nextBuildNumber");
    textSize(rect_height/2);
    int text_pos_y = (rect_height/2)+offset+(rect_height/2)/2;
     
    if (status.equals("blue")) {
      c = color(153, 204, 255);
      makeRect(0, offset, computeRectLength(build_count),rect_height, c);
      fill(255,255,255);
      String job_name = name.replaceAll(replace, "");
      float text_width = textWidth(job_name);
      text(job_name, -text_width-text_pos_x, text_pos_y);
      fill(255, 255, 255);
      text("#"+(int)build_count, computeRectLength(build_count)-textWidth(String.valueOf(build_count)), text_pos_y);
      success_builds+=1;
    }
    if (status.equals("notbuilt")) {
      c = color(120, 120, 120);
      makeRect(0, offset, computeRectLength(build_count), rect_height, c);
      fill(255,255,255);
      String job_name = name.replaceAll(replace, "");
      float text_width = textWidth(job_name);
      text(job_name, -text_width-text_pos_x, text_pos_y);
      fill(255, 255, 255);
      text("#"+(int)build_count, computeRectLength(build_count)-textWidth(String.valueOf(build_count)), text_pos_y); 
    }
    if (status.equals("red")) {
      c = color (255, 102, 104);
      makeRect(0, offset, (int)computeRectLength(build_count), rect_height, c);
      fill(255,255,255);
      String job_name = name.replaceAll(replace, "");
      float text_width = textWidth(job_name);
      text(job_name, -text_width-text_pos_x, text_pos_y);
      fill(255, 255, 255);
      text("#"+(int)build_count, computeRectLength(build_count)-textWidth(String.valueOf(build_count)), text_pos_y); 
    }
    if (status.contains("_anime")) {
      c = color (100, 100, 100);
      makeRect(0, offset, computeRectLength(build_count), rect_height, c);
      fill(255,255,255);
      String job_name = name.replaceAll(replace, "");
      float text_width = textWidth(job_name);
      text(job_name, -text_width-text_pos_x, text_pos_y);
      fill(255, 255, 255);
      text("#"+(int)build_count, computeRectLength(build_count)-textWidth(String.valueOf(build_count)), text_pos_y);  
    }
      
    offset+=rect_height+spacer;
      
  }
  
  popMatrix();
  
  int fixed_text_size = 30;
  textSize(fixed_text_size);
  fill(255, 255, 255);
  text("LSP-CSRA INTEGRATION TESTING", 100, height-180+fixed_text_size); 
  
  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.

  String day = String.valueOf(d);
  String mon = String.valueOf(m);
  String yea = String.valueOf(y);
  
  fill(253, 152, 51);
  text(day+"/"+mon+"/"+yea+"", 150, height-150+fixed_text_size);  
  
  int percentage = 100/number_of_jobs*success_builds;
  
  fill(153, 204, 255);
  textSize(fixed_text_size*1.5);
  String dummy_text = "TEST PASSING 100%";
  float text_width = textWidth(dummy_text);
  text("TEST PASSING: "+Integer.toString(percentage)+"%", width/2-text_width/2, height-180+fixed_text_size);
  
  TTS("WARNING%20ONLY%20"+Integer.toString(percentage)+"%20OF%20ALL%20TESTS%20ARE%20PASSING");
  
}

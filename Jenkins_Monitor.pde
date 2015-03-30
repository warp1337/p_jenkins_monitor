import http.requests.*;

JSONObject jenkins_json;
JSONArray jenkins_data;
int textsize = 12;
int y_offset = 50;
long start;

void setup() {
  // GFX Setup
  frameRate(1);
  size(1200, 600);
  background(128,128,128);
  
  // Timing
  start = System.currentTimeMillis() / 1000L;
  
  // Jenkins Data
  jenkins_json = getJenkinsBuildInfo();
  jenkins_data = jenkins_json.getJSONArray("jobs");
  
}

JSONObject getJenkinsBuildInfo() {
  GetRequest get = new GetRequest("http://localhost:8181/view/INTEGRATION/api/json");
  get.send();
  JSONObject response = parseJSONObject(get.getContent());
  return response;
}

void makeRect(int x, int y, float w, float h, color c) {
  fill(c);
  rect(x, y, w, h);
}

void draw() {
  
  long now = System.currentTimeMillis() / 1000L;
  if (now-start > 60) {
    jenkins_json = getJenkinsBuildInfo();
    start = System.currentTimeMillis() / 1000L;
  }
  
  smooth();
  pushMatrix();
  translate((width/2)-200, y_offset);
  
  int offset = 0;
  int number_of_jobs = jenkins_data.size();
  int rect_height = (height-100)/number_of_jobs;
  
  for (int i = 0; i < jenkins_data.size(); i++) {
    
    JSONObject job = jenkins_data.getJSONObject(i);
    String status = job.getString("color");
    String name = job.getString("name");
    String url = job.getString("url");
    
    color c;
    textSize(textsize);
    int text_pos_y = rect_height/2+offset+5;
    int text_pos_x = 10;
    
    if (status.equals("blue")) {
      c = color(0, 191, 255);
      makeRect(0,offset,400.0,rect_height, c);
      fill(128,128,128);
      text(name.replaceAll("-toolkit-lsp-csra-integration-tests-nightly", ""), text_pos_x, text_pos_y); 
    }
    if (status.equals("notbuilt")) {
      c = color(80, 80, 80);
      makeRect(0,offset,400.0,rect_height, c);
      fill(255, 255, 255);
      text(name, text_pos_x, text_pos_y); 
    }
    if (status.equals("red")) {
      c = color (255, 69, 0);
      makeRect(0,offset,400.0,rect_height, c);
      fill(128,128,128);
      text(name, text_pos_x, text_pos_y); 
    }
    
    offset+=rect_height;
    
  }
  
  popMatrix();
  
}

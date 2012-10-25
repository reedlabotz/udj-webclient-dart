#library('app_view');
#import('dart:html');

class AppView {
  Element top_bar;
  Element main_content;
  
  AppView(Element top_bar, Element main_content){
    this.top_bar = top_bar;
    this.main_content = main_content;
  }
  
  void show_logged_in(){
    this.top_bar.style.display = "block";
    this.main_content.style.display = "block";
  }
}

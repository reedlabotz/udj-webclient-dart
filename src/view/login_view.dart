#library("login_view");
#import("dart:html");

class LoginView {
 Element box;
 InputElement username;
 InputElement password;
 FormElement login_form;
 Element error;
 
 Function submitted_callback;
 
 LoginView(Element box){
   this.box = box;
   this.username = this.box.query("#username");
   this.password = this.box.query("#password");
   this.login_form = this.box.query("#login-form");
   this.error = this.box.query("#login-error");
   this.login_form.on.submit.add((e) => this._submitted(e));
   
 }
 
 void register_submitted_callback(Function callback){
   this.submitted_callback = callback;
 }
 
 void hide(){
   this.box.hidden = true;
 }
 
 void show(){
   this.box.hidden = false;
 }
 
 void show_error(){
   this.error.style.display = "block";
 }
 
 String getUsername(){
   return this.username.value;
 }
 
 String getPassword(){
   return this.password.value;
 }
 
 void _submitted(Event e){
   this.submitted_callback();
   e.preventDefault();
 }
}

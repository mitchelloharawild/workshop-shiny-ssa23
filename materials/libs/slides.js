function update_output_text() {
  document.getElementById("output_server_text").textContent='## [1] "'+document.getElementById('input_user_text').value+'"';
}

window.addEventListener('load', function() {
  document.getElementById("input_user_text").onchange = function() {update_output_text()};
});

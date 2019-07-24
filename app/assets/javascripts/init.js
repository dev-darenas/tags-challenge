var App = function () {
  return {
    init: function () {
      $(".form-select").select2({
        tags: true,
        tokenSeparators: [',', ' ']
      })
    }
  }
}();

jQuery(document).ready(function () {
  App.init(); // init core componets
});
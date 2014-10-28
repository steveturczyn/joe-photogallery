jQuery ->
  $('.dropdown-toggle').dropdown()
  $('body').addClass('ie-only') if window.navigator.userAgent.indexOf('MSIE ') > 0
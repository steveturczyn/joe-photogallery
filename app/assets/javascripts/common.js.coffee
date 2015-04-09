jQuery ->
  $('.dropdown-toggle').dropdown()
  $('body').addClass('ie-only') if window.navigator.userAgent.indexOf('MSIE ') > 0

  $ ->
    flashCallback = ->
      $(".alert").fadeOut()
    $(".alert").bind 'click', (ev) =>
      $(".alert").fadeOut()
    setTimeout flashCallback, 15000
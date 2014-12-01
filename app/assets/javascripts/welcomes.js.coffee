jQuery ->
  $('#home-carousel').on 'slide.bs.carousel', (e) ->
    item = $(e.relatedTarget)
    first_name = item.data('user-first-name')
    full_name = item.data('user-full-name')
    $('#header').find('name').html(full_name)
    $('#header').find('firstname').html("#{first_name}'s")
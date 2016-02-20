var auto_popups = {items: []};

// {dom_id: '', title: '', content: '', location: '', condition: '', duration: 0}

always_true = function(){ return true; }

auto_popups.show_popups = function(){
  all_items = auto_popups['items'];
  auto_popups['items'] = [];
  $.each(all_items, function(idx, item){
    if(window[item['condition']['name']](item['condition']['args'])){
      if(item['delay']){
        setTimeout(function(p_item){
          auto_popups.display(p_item);
        }, item['delay'] * 1000, item);
      } else {
        auto_popups.display(item);
      }
    } else {
      auto_popups['items'].push(item);
    }
  });
}

auto_popups.display = function(item){
  if(item['dom_id']){
    target = '#' + item['dom_id'];
  } else {
    target = item['filter'];
  }
  $(target).popover({
    content: item['content'],
    html: true,
    placement: item['location'],
    title: item['title'] + '<button type="button" class="pull-right close pcloser">&times;</button><div class="clearfix"/>'
  }).popover('show');
  $('.pcloser').click(function(){
    pover = $(this).parents('.popover');
    pover.popover('hide');
    pover.popover('destroy');
  });
  if(item['duration']){
    setTimeout(function(){
      $('#' + item['dom_id']).popover('hide');
      $('#' + item['dom_id']).popover('destroy');
    }, item['duration'] * 1000);
  }
}

$(document).ajaxComplete(auto_popups.show_popups);
$(document).ready(auto_popups.show_popups);

var auto_popups = {items: []};

// {dom_id: '', title: '', content: '', location: '', condition: '', duration: 0}

always_true = function(){ return true; }

auto_popups.show_popups = function(){
  all_items = auto_popups['items'];
  auto_popups['items'] = [];
  $.each(all_items, function(idx, item){
    if(window[item['condition']['name']](item['condition']['args'])){
      auto_popups.display(item)
    } else {
      auto_popups['items'].push(item);
    }
  });
}

auto_popups.display = function(item){
  $('#' + item['dom_id']).popover({
    content: item['content'],
    html: true,
    placement: item['location'],
    title: item['title']
  }).popover('show');
  if(item['duration']){
    setTimeout(function(){
      $('#' + item['dom_id']).popover('hide');
    }, item['duration'] * 1000);
  }
}

NOVAHawk.toolbars = {};

NOVAHawk.toolbars.findByDataClick = function (toolbar, attr_click) {
  return $(toolbar).find("[data-click='" + attr_click + "']");
};

NOVAHawk.toolbars.enableItem = function (toolbar, attr_click) {
  NOVAHawk.toolbars.findByDataClick(toolbar, attr_click).removeClass('disabled');
  NOVAHawk.angular.rxSubject.onNext({update: attr_click, type: 'enabled', value: true});
};

NOVAHawk.toolbars.disableItem = function (toolbar, attr_click) {
  NOVAHawk.toolbars.findByDataClick(toolbar, attr_click).addClass('disabled');
  NOVAHawk.angular.rxSubject.onNext({update: attr_click, type: 'enabled', value: false});
};

NOVAHawk.toolbars.setItemTooltip = function (toolbar, attr_click, tooltip) {
  NOVAHawk.toolbars.findByDataClick(toolbar, attr_click).attr('title', tooltip);
  NOVAHawk.angular.rxSubject.onNext({update: attr_click, type: 'title', value: tooltip});
};

NOVAHawk.toolbars.showItem = function (toolbar, attr_click) {
  NOVAHawk.toolbars.findByDataClick(toolbar, attr_click).show();
  NOVAHawk.angular.rxSubject.onNext({update: attr_click, type: 'hidden', value: true});
};

NOVAHawk.toolbars.hideItem = function (toolbar, attr_click) {
  NOVAHawk.toolbars.findByDataClick(toolbar, attr_click).hide();
  NOVAHawk.angular.rxSubject.onNext({update: attr_click, type: 'hidden', value: true});
};

NOVAHawk.toolbars.markItem = function (toolbar, attr_click) {
  NOVAHawk.toolbars.findByDataClick(toolbar, attr_click).addClass('active');
  NOVAHawk.angular.rxSubject.onNext({update: attr_click, type: 'selected', value: true});
};

NOVAHawk.toolbars.unmarkItem = function (toolbar, attr_click) {
  NOVAHawk.toolbars.findByDataClick(toolbar, attr_click).removeClass('active');
  NOVAHawk.angular.rxSubject.onNext({update: attr_click, type: 'selected', value: false});
};

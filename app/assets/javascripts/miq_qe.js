NOVAHawk.qe.get_debounce_index = function () {
  if (NOVAHawk.qe.debounce_counter > 30000) {
    NOVAHawk.qe.debounce_counter = 0;
  }
  return NOVAHawk.qe.debounce_counter++;
};

if (typeof _ !== 'undefined' && typeof _.debounce !== 'undefined') {
  var orig_debounce = _.debounce;
  _.debounce = function(func, wait, options) {
    var debounce_index = NOVAHawk.qe.get_debounce_index();

    // Override the original fn; new_func will be the original fn with wait prepended to it
    // We make sure that once this fn is actually run, it decreases the counter
    var new_func = function() {
      try {
        return func.apply(this, arguments);
      } finally {
        // this is run before the return above, always
        delete NOVAHawk.qe.debounced[debounce_index];
      }
    };
    // Override the newly-created fn (prepended wait + original fn)
    // We have to increase the counter before the waiting is initiated
    var debounced_func = orig_debounce.call(this, new_func, wait, options);
    var new_debounced_func = function() {
      NOVAHawk.qe.debounced[debounce_index] = 1;
      return debounced_func.apply(this, arguments);
    };
    return new_debounced_func;
  };
}

NOVAHawk.qe.xpath = function(root, xpath) {
  if (root == null) {
     root = document;
  }
  return document.evaluate(xpath, root, null,
    XPathResult.ANY_UNORDERED_NODE_TYPE, null).singleNodeValue;
};

NOVAHawk.qe.isHidden = function(el) {
  if (el === null) {
    return true;
  }
  return el.offsetParent === null;
};

NOVAHawk.qe.setAngularJsValue = function (el, value) {
  var angular_elem = angular.element(elem);
  var $parse = angular_elem.injector().get('$parse');
  var getter = $parse(elem.getAttribute('ng-model'));
  var setter = getter.assign;
  angular_elem.scope().$apply(function($scope) { setter($scope, value); });
};

NOVAHawk.qe.anythingInFlight = function() {
  var state = NOVAHawk.qe.inFlight();

  return (state.autofocus != 0) ||
    (state.debounce) ||
    (state.document != 'complete') ||
    (state.jquery != 0) ||
    (state.spinner);
};

NOVAHawk.qe.spinnerPresent = function() {
  return (!NOVAHawk.qe.isHidden(document.getElementById("spinner_div"))) &&
     NOVAHawk.qe.isHidden(document.getElementById("lightbox_div"));
};

NOVAHawk.qe.debounceRunning = function() {
  return Object.keys(NOVAHawk.qe.debounced).length > 0;
};

NOVAHawk.qe.inFlight = function() {
  return {
    autofocus:  NOVAHawk.qe.autofocus,
    debounce:   NOVAHawk.qe.debounceRunning(),
    document:   document.readyState,
    jquery:     $.active,
    spinner:    NOVAHawk.qe.spinnerPresent(),
  };
};

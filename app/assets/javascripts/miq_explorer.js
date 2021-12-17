NOVAHawk.explorer = {};

NOVAHawk.explorer.updateElement = function(element, options) {
  if (_.isString(options.legend)) {
    $('#' + element).html(options.legend);
  } else if (_.isString(options.title)) {
    $('#' + element).attr( {'title': options.title});
  } else if (_.isString(options.class)) {
    if (options.add) {
      $('#' + element).addClass(options.class);
    } else {
      $('#' + element).removeClass(options.class);
    }
  }
};

NOVAHawk.explorer.buildCalendar = function(options) {
  NOVAHawk.calendar.calDateFrom = _.isString(options.dateFrom) ? new Date(options.dateFrom) : undefined;
  NOVAHawk.calendar.calDateTo = _.isString(options.dateTo) ? new Date(options.dateTo) : undefined;
  NOVAHawk.calendar.calSkipDays = _.isObject(options.skipDays) ? options.skipDays : undefined;

  miqBuildCalendar();
};

NOVAHawk.explorer.lock_tree = function(tree_name, lock) {
  var tree = miqTreeObject(tree_name);
  if (!tree || "length" in tree) {
    // "length" in tree - because miqTreeObject returns a jquery array when the element doesn't exist
    // https://github.com/patternfly/patternfly-bootstrap-treeview/issues/16
    console.warn("Attempting to lock_tree a tree which doesn't exist", tree_name, lock);
    return;
  }

  lock ? tree.disableAll({silent: true, keepState: true}) : tree.enableAll();
  miqDimDiv('#' + tree_name + '_div', lock);
};

NOVAHawk.explorer.clearSearchToggle = function(show) {
  if (show) {
    $('#clear_search').show();
  } else {
    $('#clear_search').hide();
  }
};

NOVAHawk.explorer.process = function(data) {
  switch (data.explorer) {
    case 'flash':
      NOVAHawk.explorer.processFlash(data);
      break;
    case 'replace_right_cell':
      NOVAHawk.explorer.processReplaceRightCell(data);
      break;
    case 'replace_main_div':
      NOVAHawk.explorer.processReplaceMainDiv(data);
      break;
    case 'buttons':
      NOVAHawk.explorer.processButtons(data);
      break;
    case 'window':
      NOVAHawk.explorer.processWindow(data);
      break;
  }
};

NOVAHawk.explorer.processWindow = function(data) {
  if (_.isString(data.openUrl)) {
    window.open(data.openUrl);
  }
  NOVAHawk.explorer.spinnerOff(data);
};

NOVAHawk.explorer.processButtons = function(data) {
  NOVAHawk.explorer.miqButtons(data);
};

NOVAHawk.explorer.processReplaceMainDiv = function(data) {
  NOVAHawk.explorer.updatePartials(data);
};

NOVAHawk.explorer.processFlash = function(data) {
  NOVAHawk.explorer.replacePartials(data);
  NOVAHawk.explorer.spinnerOff(data);
  NOVAHawk.explorer.scrollTop(data);
  NOVAHawk.explorer.focus(data);
};

NOVAHawk.explorer.replacePartials = function(data) {
  if (_.isObject(data.replacePartials)) {
    _.forEach(data.replacePartials, function (content, element) {
      $('#' + element).replaceWith(content);
    });
  }
};

NOVAHawk.explorer.updatePartials = function(data) {
  if (_.isObject(data.updatePartials)) {
    _.forEach(data.updatePartials, function (content, element) {
      $('#' + element).html(content);
    });
  }
};

NOVAHawk.explorer.spinnerOff = function(data) {
  if (data.spinnerOff) {
    miqSparkle(false);
  }
};


NOVAHawk.explorer.scrollTop = function(data) {
  if (data.scrollTop) {
    $('#main_div').scrollTop(0);
  }
};

NOVAHawk.explorer.miqButtons = function(data) {
  miqButtons(data.showMiqButtons ? 'show' : 'hide');
};

NOVAHawk.explorer.focus = function(data) {
  if (_.isString(data.focus)) {
    var element = $('#' + data.focus);
    if ( element.length ) element.focus();
  }
}

NOVAHawk.explorer.processReplaceRightCell = function(data) {
  /* variables for the expression editor */
  if (_.isObject(data.expEditor)) {
    if (_.isObject(data.expEditor.first)) {
      if (!_.isUndefined(data.expEditor.first.type)) {
        NOVAHawk.expEditor.first.type   = data.expEditor.first.type;
      }
      if (!_.isUndefined(data.expEditor.first.title)) {
        NOVAHawk.expEditor.first.title  = data.expEditor.first.title;
      }
    }

    if (_.isObject(data.expEditor.second)) {
      if (!_.isUndefined(data.expEditor.second.type)) {
        NOVAHawk.expEditor.second.type   = data.expEditor.second.type;
      }
      if (!_.isUndefined(data.expEditor.second.title)) {
        NOVAHawk.expEditor.second.title  = data.expEditor.second.title;
      }
    }
  }

  NOVAHawk.explorer.miqButtons(data);

  if (_.isString(data.clearTreeCookies)) { miqDeleteTreeCookies(data.clearTreeCookies); }

  if (_.isString(data.accordionSwap)) {
    miqAccordionSwap('#accordion .panel-collapse.collapse.in', '#' + data.accordionSwap + '_accord');
  }

  /* dealing with tree nodes */
  if (!_.isUndefined(data.addNodes)) {

    if (data.addNodes.remove) {
      miqRemoveNodeChildren(data.addNodes.activeTree, data.addNodes.key);
    }

    miqAddNodeChildren(data.addNodes.activeTree,
                       data.addNodes.key,
                       data.addNodes.osf,
                       data.addNodes.nodes);
  }


  if (!_.isUndefined(data.deleteNode)) {
    var del_node = miqTreeFindNodeByKey(data.deleteNode.activeTree, data.deleteNode.node)
    miqTreeObject(data.deleteNode.activeTree).deleteNode(del_node);
  }

  if (_.isString(data.dashboardUrl)) {
    NOVAHawk.widget.dashboardUrl = data.dashboardUrl;
  }

  if ($('#advsearchModal').hasClass('modal fade in')) {
    $('#advsearchModal').modal('hide');
  }

  NOVAHawk.explorer.updatePartials(data);

  if (_.isObject(data.updateElements)) {
    _.forEach(data.updateElements, function (options, element) {
        NOVAHawk.explorer.updateElement(element, options);
    });
  }

  NOVAHawk.explorer.replacePartials(data);

  if (_.isObject(data.buildCalendar)) { NOVAHawk.explorer.buildCalendar(data.buildCalendar); }

  if (data.initDashboard) { miqInitDashboardCols(); }

  if (data.clearGtlListGrid) { NOVAHawk.grids.gtl_list_grid = undefined; }

  if (_.isObject(data.setVisibility))
    _.forEach(data.setVisibility, function (visible, element) {
      if ( miqDomElementExists(element) ) {
        if ( visible ) {
          $('#' + element).show()
        } else {
          $('#' + element).hide()
        }
      }
    });

  NOVAHawk.explorer.scrollTop(data);

  if (_.isString(data.rightCellText)) {
    $('h1#explorer_title > span#explorer_title_text')
      .html(data.rightCellText);
  }

  if (_.isArray(data.reloadToolbars) && data.reloadToolbars.length) {
    NOVAHawk.angular.rxSubject.onNext({
      redrawToolbar: data.reloadToolbars
    });
  } else if (_.isObject(data.reloadToolbars) && !_.isArray(data.reloadToolbars)) {
    // FIXME remove this branch completely once sure
    console.error('Found a toolbar using the obsolete path! Please report or fix');

    _.forEach(data.reloadToolbars, function (content, element) {
      $('#' + element).html(content);
    });
    miqInitToolbars();
  }

  NOVAHawk.record = data.record;

  if (!_.isUndefined(data.activateNode)) {
    miqExpandParentNodes(data.activateNode.activeTree, data.activateNode.osf);
    miqTreeActivateNodeSilently(data.activateNode.activeTree, data.activateNode.osf);
  }

  if (_.isObject(data.lockTrees)) {
    _.forEach(data.lockTrees, function (lock, tree) {
      NOVAHawk.explorer.lock_tree(tree, lock);
    });
  }

  if (_.isObject(data.chartData)) {
    NOVAHawk.charts.chartData = data.chartData;
    load_c3_charts();
  }

  if (data.resetChanges) { NOVAHawk.changes = null; }
  if (data.resetOneTrans) { NOVAHawk.oneTransition.oneTrans = 0; }
  if (data.oneTransIE) { NOVAHawk.oneTransition.IEButtonPressed = true; }

  NOVAHawk.explorer.focus(data);

  if (!_.isUndefined(data.clearSearch)) {
    NOVAHawk.explorer.clearSearchToggle(data.clearSearch);
  }

  miqInitMainContent();
  miqInitAccordions();

  if (data.hideModal) { $('#quicksearchbox').modal('hide'); }
  if (data.initAccords) { miqInitAccordions(); }

  if (_.isString(data.ajaxUrl)) {
    miqAsyncAjax(data.ajaxUrl);
  } else {
    miqSparkleOff();
  }

  return null;
};

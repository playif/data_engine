import 'dart:html' as dom;
import 'dart:svg';

class DataEngine extends Group {

  final SvgElement svg;

  DataEngine(this.svg) :super._() {

  }

  render(Map<String, dynamic> data) {
    //_updateState(this, data, data, svg);
    _render(data, data, svg);
  }
}

class Shape {
//  final SvgElement _parentSvg;
//  final Map<String, dynamic> _parentData;
  String _path;
  String _tag;

  final List<Shape> _stateList = [];
  final List<Anim> _enterList = [];
  final List<Anim> _exitList = [];

  final Map _eventMap = {
  };
  final Map _attrMap = {
  };
  final Map _cssMap = {
  };
  final Set _classSet = new Set();

  Map _svgMap = {
  };

  Map _toBeRemovedSVG = {
  };

//  Map<String, dynamic> get _data => _parentData[path];

  Shape._([this._path]) {

  }

  Shape attr(String attr, func) {
    _attrMap[attr] = func;
    return this;
    //func(_data)
  }


  Shape css(String css, func) {
    _cssMap[css] = func;
    return this;
    //func(_data)
  }

  Shape on(String eventName, Function func) {
    _eventMap[eventName] = func;
    return this;
  }

  Shape addClass(className) {
    _classSet.add(className);
    return this;
  }

  Shape removeClass(className) {
    _classSet.remove(className);
    return this;
  }

  dynamic _text;

  Shape text(func) {
    _text = func;
    return this;
    //func(_data)
  }

  Anim enter([String path, String tag]) {
    Anim state = new Anim._(path);
    //print(state._path);
    state._tag = (tag != null) ? tag : 'transform';
    state.attr("attributeName", "transform");

    _enterList.add(state);
    return state;
  }

  Anim exit([String path, String tag]) {
    Anim state = new Anim._(path);
    //print(state._path);
    state._tag = (tag != null) ? tag : 'transform';
    state.attr("attributeName", "transform");

    _exitList.add(state);
    //print(_exitList);
    return state;
  }

//  void cacheSvg() {
//    //print(_svgMap);
//    _toBeRemovedSVG = _svgMap;
//    _svgMap = {
//    };
//  }

//  void reviseSvg() {
//    _svgMap = _toBeRemovedSVG;
//    _toBeRemovedSVG = {
//    };
//  }

  dom.Element _getElement(d) {
    dom.Element element;
    switch (_tag) {
      case 'circle':
        element = new CircleElement();
        break;
      case 'rect':
        element = new RectElement();
        break;
      case 'text':
        element = new TextElement();
        break;
      case 'g':
        element = new GElement();
        break;
      case 'anim':
        element = new AnimateElement();
        break;
      case 'set':
        element = new SetElement();
        break;
      case 'transform':
        element = new AnimateTransformElement();
        break;
//        case 'transform':
//          element = new AnimateTransformElement();
//          break;
    }
    _setEnterAnim(element, d);
    _setEvent(element, d);

    return element;
  }

  _setEnterAnim(element, d) {
    for (var a in _enterList) {
      AnimationElement anim = a._getElement(d);
      a._setAttr(anim, d);
      element.append(anim);
    }
  }

  _setExitAnim(element, d) {
    int count = _exitList.length;

    remove(e) {
      count --;
      if (count == 0) {
        element.remove();
      }
    }

    for (var a in _exitList) {
      AnimationElement anim = a._getElement(d);
      anim.addEventListener('endEvent', remove);
      a._setAttr(anim, d);
      element.append(anim);
    }
  }

  _setAttr(dom.Element element, d) {
    for (var attr in _attrMap.keys) {
      var value = _getFunctionString(_attrMap[attr], d);
      ;
      var cur = element.getAttribute(attr);
      if (cur != value) {
        element.setAttribute(attr, value);
      }
    }
  }

  _setCSS(dom.Element element, d) {
    for (var attr in _cssMap.keys) {
      var value = _getFunctionString(_cssMap[attr], d);
      var cur = element.style.getPropertyValue(attr);
      if (cur != value) {
        element.style.setProperty(attr, value);
      }
    }
  }


  _setClass(dom.Element element, d) {
    for (var attr in _classSet) {
      var value = _getFunctionString(attr, d);
      if (!element.classes.contains(value)) {
        element.classes.add(value);
      }
    }
  }

  _getFunctionString(func, d) {
    if (func is Function) {
      return "${func(d)}";
    } else {
      return "${func}";
    }
  }

  _setEvent(dom.Element element, d) {
    for (var attr in _eventMap.keys) {
      event(e) {
        _eventMap[attr](e, d);
        _render(d, d, element);
      }
      element.addEventListener(attr, event);
    }
  }


  void updateProperty(element, d) {
    if (_text != null) {
      element.text = _getFunctionString(_text, d);
    }

    _setAttr(element, d);
    _setCSS(element, d);
    _setClass(element, d);
  }

  dom.Element _updateSingleTag(d, panel) {
    dom.Element element;
    if (_svgMap.containsKey(d)) {
      element = _svgMap[d];
      updateProperty(element, d);
    }
    else {
      element = _getElement(d);
      _svgMap[d] = element;
      updateProperty(element, d);
      panel.append(element);
    }

    //_setEvent(element, d);

    return element;
  }

  void _setupRemove(panel) {
    for (var d in _svgMap.keys) {
      var dPanel = _svgMap[d].parent;
      if (dPanel == panel) {
        _toBeRemovedSVG[d] = _svgMap[d];
      }
    }
  }

  dom.Element _updateTag(d, panel) {
    dom.Element element;

    if (_toBeRemovedSVG.containsKey(d)) {
      element = _toBeRemovedSVG[d];
      updateProperty(element, d);
      _toBeRemovedSVG.remove(d);
    }
    else {
      //print("create");
      //print(_tag);

      element = _getElement(d);
      updateProperty(element, d);

      _svgMap[d] = element;
      panel.append(element);
    }


    //_setEvent(element, d);

    return element ;
  }


//  State bind(String path) {
//    var data = _data[path];
//    State state;
//    if (data is List) {
//      state = new State._(data, _svg);
//    }
//    else {
//      state = new State._(data, _svg);
//
//
//    }
//
//    stateList.add(state);
//    return state;
//  }

//  State add(StateElement element) {
//
//
//    return this;
//  }

  _getTargetData(data, rootData) {
    var targetData;
    if (_path != null) {
      //TODO data path
      targetData = data[_path];
    }
    else {
      targetData = data;
    }
    return targetData;
  }

  void _updateState(Shape state, Map<String, dynamic> data, rootData, dom.Element panel) {

    var targetData = state._getTargetData(data, rootData);


    if (targetData != null) {

      if (targetData is List) {
        //TODO sync svg element
        state._setupRemove(panel);

        //state.cacheSvg();
        for (var d in targetData) {
          state._updateTag(d, panel);
        }


        for (var d in state._toBeRemovedSVG.keys) {
          var svg = state._toBeRemovedSVG[d];
          state._setExitAnim(svg, d);

          //svg.remove();
        }

        state._toBeRemovedSVG.clear();

        for (var d in targetData) {
          state._render(d, rootData, state._svgMap[d]);
        }

      }

      else {
        var element = state._updateSingleTag(targetData, panel);
        state._render(targetData, rootData, element);
      }
    }
    else {
      for (var d in state._svgMap.keys) {
        var svg = state._svgMap[d];
        if (svg.parent == panel) {
          state._setExitAnim(svg, d);
          //svg.remove();
        }
      }
    }
  }

  void _render(Map<String, dynamic> data, rootData, dom.Element panel) {
    for (Shape state in _stateList) {
      _updateState(state, data, rootData, panel);
    }
  }


//  State bindList(String path) {
//    var data = _data[path];
//    State state = new State._(data, _svg);
//    stateList.add(state);
//
//    return state;
//  }


//  State bind(String name) {
//    _data = data;
//
//    return this;
//  }

  Anim addAnimation([String path]) {
    Anim state = new Anim._(path);
    //print(state._path);
    state._tag = 'anim';
    _stateList.add(state);
    return state;
  }

  Anim addSet([String path]) {
    Anim state = new Anim._(path);
    //print(state._path);
    state._tag = 'set';
    _stateList.add(state);
    return state;
  }

  Anim addTransform([String path]) {
    Anim state = new Anim._(path);
    //print(state._path);
    state._tag = 'transform';
    state.attr("attributeName", "transform");

    _stateList.add(state);
    return state;
  }

  Shape append(String path, String tag) {

    Shape state = new Shape._(path);
    //print(state._path);
    state._tag = tag;
    _stateList.add(state);
    return state;
  }

}

//class StateElement {
//  //dom.Element _element;
//
//
//  StateElement(this.tagName) {
//
//  }
//
//
//}

class Group extends Shape {
  Group._([String path]):super._(path);

  Shape addCircle([String path]) {
    return append(path, 'circle');
  }

  Shape addRect([String path]) {
    return append(path, 'rect');
  }

  Shape addText([String path]) {
    return append(path, 'text');
  }


  Group addGroup([String path]) {
    Group state = new Group._(path);
    state._tag = 'g';
    _stateList.add(state);
    return state;
  }
}

class Text extends Shape {
  Text._([String path]):super._(path){
  }


}

class Anim extends Shape {
  Anim._([String path]):super._(path){
    this.attr("attributeType", "xml");
    this.attr("begin", "DOMNodeInserted");
  }


}


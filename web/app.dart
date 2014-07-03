import 'dart:html';
import 'dart:svg';
import 'dart:async';
import 'dart:math';
import 'package:data_engine/data_engine.dart';


main() {
  //Expando<String> d=new Expando<String>();

  Function bind(String name) {
    return (d) => d[name];
  }

  Map<String, dynamic> data = {
      "name":"Tim",
      "list":[],
      "FPS":0
  };

  var rand = new Random();
  for (var i = 0;i < 11;i++) {
    for (var j = 0;j < 11;j++) {
      data['list'].add({
          'name':'b',
          'r':20,
          'x':i * 22 + 11,
          'y':j * 22 + 11,
          'rotate':0,
          'color':'blue',
          'speed':rand.nextInt(5) + 2
      });
    }
  }

  SvgSvgElement svg = querySelector('svg');

  var engine = new DataEngine(svg);
  //var panel = engine.addGroup();
  //.attr('fill', 'red')
  //.css('pointer-events', 'all')
  window.onMouseMove.listen((e) {
    //var element = e.target;
    //window.console.log(element);
    var p = svg.createSvgPoint();
    p.x = e.page.x;
    p.y = e.page.y;
    Matrix mat = svg.getScreenCtm().inverse();
    p = p.matrixTransform(mat);
    //window.console.log(e.target.getScreenCtm());
    //window.console.log(e);
//    if(element is SvgElement){
//      SvgElement svg=element;
//      SvgSvgElement parent=svg.ownerSvgElement;
//      parent.create
//      window.console.log(e);
//    }
    data['FPS'] = '${p.x.ceil()},${p.y.ceil()}';
    //print('moved');
  });

  Group group = engine.addGroup('list')
  .attr('stroke-width', (d) => 1)
// .attr('transform',(d) =>'')
  .attr('transform', (d) => 'translate(${d['x']} ${d['y']})  ')
  .on('mouseenter', (e, d) {
    d['color'] = 'red';
  })
  .on('mouseleave', (e, d) {
    d['color'] = 'blue';
  })
//  .translate(bind('cx'), bind('cy'))
  ;

  Shape circle = group.addRect()
//  .attr('cx', (d) => 0)
//  .attr('cy', (d) => 0)
//    .attr('r', 10)
  .attr('x', -10)
  .attr('y', -10)
  .attr('width', 20)
  .attr('height', 20)
  .attr('id', bind('name'))
  .attr('stroke', bind('color'))
  .attr('fill', (d) => "pink")

  ;


  Shape circle2 = group.addRect()
  .attr('x', (d) => -6)
  .attr('y', (d) => -3)
  //  .attr('cy', (d) => d['cy']+15)
  .attr('r', 15)
  .attr('width', 12)
  .attr('height', 6)
  .attr('id', bind('name'))
  .attr('stroke', bind('color'))
  .attr('stroke-width', 1)
  .attr('transform', (d) => 'rotate(${d['rotate']})')
  .css('pointer-events', 'stroke')
  ;

  engine.addText()
  .text(bind('FPS'))
  .attr("x", 300)
  .attr("y", 30)
  .attr("font-size", 24)
  .attr("fill", "red")
  .attr('stroke', (d) => "green");
//  .on('click', (e, d) {
//    //d['r'] += 100;
//    engine.render(data);
//    //circle.attr('stroke', (d) => "green");
//    print(e);
//  })
//  .addAnimation()
  ////  .attr('attributeType', 'css')
//  .attr('attributeName', 'cx')
//  .attr('begin', "click")
//  .attr('from', 1)
//  .attr('to', 1000)
//  // .attr('fill', 'freeze')
//  .attr('dur', 2)
//
//  .addClass('mean');


  var lastTime = 0;
  engine.render(data);

  loop(num delta) {
    var dt = delta - lastTime;
    lastTime = delta;
    for (var i = 0;i < data['list'].length;i++) {
      //      data['list'][i]['cx'] += data['list'][i]['speed'] * dt / 100;
      //      data['list'][i]['cx'] %= 400;
      //data['list'][i]['rotate'] += 20 * dt / 100;
    }
    engine.render(data);
    //data['FPS'] = 1000 / dt;

    //print(1000 / dt);
    window.animationFrame.then(loop);
  }


 //window.animationFrame.then(loop);

//  group.exit('anim')
//  .attr('type', 'scale')
//  .attr('values', '1;0;2')
//  .attr('fill', 'freeze')
//  .attr('dur', bind('name'));
//
//  group.exit('anim', 'anim')
//  .attr('attributeType', 'css')
//  .attr('attributeName', 'opacity')
//  .attr('values', '1;0;1;0;1;0;1;0;1;0;1')
//  .attr('fill', 'freeze')
//  .attr('dur', bind('name'));

//  Shape rect = group.addRect()
//  .attr('x', (d) => d['cx'])
//  .attr('y', (d) => 20)
//  .attr('width', (d) => d['r'])
//  .attr('height', (d) => d['r'])
//  .attr('stroke', (d) => "green");
//
//  Text text = group.addText()
//  .attr('x', (d) => d['cx'])
//  .attr('y', (d) => 20)
//  .attr('width', (d) => d['r'])
//  .attr('height', (d) => d['r'])
//  .text((d) => "yellow");
//
//  engine.render(data);
//  engine.render(data);
//  var timer = new Timer(const Duration(seconds:2), () {
//    List list = data['list'];
//    list.removeLast();
//
//    engine.render(data);
//  });
  //engine.render(data);
  //g.bind('list').append(20, 20, 10).attr('r', (d) => d['r']);

}

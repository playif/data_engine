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
  for (var i = 0;i < 500;i++) {
    data['list'].add({
        'name':'b',
        'r':20,
        'cx':rand.nextInt(400),
        'cy':rand.nextInt(400),
        'rotate':10,
        'speed':rand.nextInt(5)+2,
        'anim':[{
            'name':1
        }, {
            'name':2
        }]
    });
  }

  var engine = new DataEngine(querySelector('svg'));


  Group group = engine.addGroup('list')
  .attr('stroke-width', (d) => 2)
// .attr('transform',(d) =>'')
  .attr('transform', (d) => 'translate(${d['cx']} ${d['cy']}) rotate(${d['rotate']}) scale(0.2 0.2)')
//  .translate(bind('cx'), bind('cy'))
  ;

  Shape circle = group.addCircle()
//  .attr('cx', (d) => 0)
//  .attr('cy', (d) => 0)
  .attr('r', 60)
//  .attr('x', (d) => -30000)
//  .attr('y', (d) => -30)
  .attr('width', 60)
  .attr('height', 60)
  .attr('id', bind('name'))
  .attr('stroke', (d) => "green");


  Shape circle2 = group.addRect()
  .attr('x', (d) => -60)
  .attr('y', (d) => -30)
  //  .attr('cy', (d) => d['cy']+15)
  .attr('r', 15)
  .attr('width', 120)
  .attr('height', 60)
  .attr('id', bind('name'))
  .attr('stroke', (d) => "red")
  .attr('stroke-width', 15)
  .attr('transform', (d) => 'scale(0.8 0.8) translate(0 220)');

  engine.addText()
  .text(bind('FPS'))
  .attr("x", 10)
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


  gameLoop(num delta) {
    var dt = delta - lastTime;
    lastTime = delta;
    for (var i = 0;i < data['list'].length;i++) {
      data['list'][i]['cx'] += data['list'][i]['speed'] * dt / 100;
      data['list'][i]['cx'] %= 400;
      data['list'][i]['rotate'] += 20* dt / 100;

    }
    data['FPS'] = 1000 / dt;
    engine.render(data);
    //print(1000 / dt);
    window.animationFrame.then(gameLoop);
  }


  window.animationFrame.then(gameLoop);

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

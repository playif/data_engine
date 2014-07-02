import 'dart:html' as dom;
import 'dart:svg';
import 'dart:async';
import 'package:data_engine/data_engine.dart';


main() {
  //Expando<String> d=new Expando<String>();

  Function bind(String name) {
    return (d) => d[name];
  }

  Map<String, dynamic> data = {
      "name":"Tim",
      "list":[{
          'name':1,
          'r':10,
          'cx':20,
          'anim':[{
              'name':3
          }, {
              'name':5
          }]
      }, {
          'name':2,
          'r':20,
          'cx':40,
          'anim':[{
              'name':1
          }, {
              'name':2
          }]
      }]
  };

  var engine = new DataEngine(dom.querySelector('svg'));

  Group group = engine.addGroup('list')
  .attr('stroke-width', (d) => 2);

  Shape circle = group.addCircle()
  .attr('cx', (d) => d['cx'])
  .attr('cy', (d) => 20)
  .attr('r', (d) => d['r'])
  .attr('stroke', (d) => "green")
  .on('click', (e,d) {
    d['r']+=100;
    engine.render(data);
    //circle.attr('stroke', (d) => "green");
    //print(e);
  })
  .addAnimation()
//  .attr('attributeType', 'css')
  .attr('attributeName', 'r')
  .attr('values', '100;0;100;0;100;0;100;0;1;0;1')
  .attr('fill', 'freeze')
  .attr('dur', bind('name'))

  .addClass('mean');

  group.exit('anim')
  .attr('type', 'scale')
  .attr('values', '1;0;2')
  .attr('fill', 'freeze')
  .attr('dur', bind('name'));

  group.exit('anim', 'anim')
  .attr('attributeType', 'css')
  .attr('attributeName', 'opacity')
  .attr('values', '1;0;1;0;1;0;1;0;1;0;1')
  .attr('fill', 'freeze')
  .attr('dur', bind('name'));

  Shape rect = group.addRect()
  .attr('x', (d) => d['cx'])
  .attr('y', (d) => 20)
  .attr('width', (d) => d['r'])
  .attr('height', (d) => d['r'])
  .attr('stroke', (d) => "green");

  Text text = group.addText()
  .attr('x', (d) => d['cx'])
  .attr('y', (d) => 20)
  .attr('width', (d) => d['r'])
  .attr('height', (d) => d['r'])
  .text((d) => "yellow");

  engine.render(data);
  engine.render(data);
  var timer = new Timer(const Duration(seconds:2), () {
    List list = data['list'];
    list.removeLast();

    engine.render(data);
  });
  //engine.render(data);
  //g.bind('list').append(20, 20, 10).attr('r', (d) => d['r']);

}

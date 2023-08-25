import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ExplosionParticle extends PositionComponent {
  ExplosionParticle(Vector2 vector2, {position}) : super(position: position);

  @override
  FutureOr<void> onLoad() {
    int boomParticleCount = 5;
    int boomSize = 3;
    add(ParticleSystemComponent(
        particle: Particle.generate(
            count: boomParticleCount,
            generator: (i) {
              Vector2 positionParticle = position;
              Vector2 speed = Vector2(i.toDouble() * boomSize, 0);
              final paint = Paint()..color = Colors.red;

              return ComputedParticle(renderer: (canvas, _) {
                positionParticle += speed;
                canvas.drawCircle(
                    Offset(positionParticle.x, positionParticle.y),
                    (boomParticleCount - i).toDouble() * boomSize,
                    paint);
              });
            })));
    add(ParticleSystemComponent(
        particle: Particle.generate(
            count: boomParticleCount,
            generator: (i) {
              Vector2 positionParticle = position;
              Vector2 speed = Vector2(-i.toDouble() * boomSize, 0);
              final paint = Paint()..color = Colors.red;

              return ComputedParticle(renderer: (canvas, _) {
                positionParticle += speed;
                canvas.drawCircle(
                    Offset(positionParticle.x, positionParticle.y),
                    (boomParticleCount - i).toDouble() * boomSize,
                    paint);
              });
            })));
    return super.onLoad();
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWeatherCard extends StatelessWidget {
  const LoadingWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: double.infinity, height: 56),
              const SizedBox(height: 24),
              _box(width: 160, height: 28),
              const SizedBox(height: 8),
              _box(width: 120, height: 18),
              const SizedBox(height: 40),
              Center(child: _box(width: 170, height: 90)),
              const SizedBox(height: 32),
              _box(width: double.infinity, height: 150),
              const SizedBox(height: 24),
              _box(width: 180, height: 24),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(child: _ForecastSkeletonBox()),
                  SizedBox(width: 12),
                  Expanded(child: _ForecastSkeletonBox()),
                  SizedBox(width: 12),
                  Expanded(child: _ForecastSkeletonBox()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _ForecastSkeletonBox extends StatelessWidget {
  const _ForecastSkeletonBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
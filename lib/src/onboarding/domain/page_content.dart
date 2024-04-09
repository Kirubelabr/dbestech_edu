import 'package:dbestech_edu/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
    image: MediaRes.casualReading,
    title: 'Brand new curriculum',
    description: 'This is the first online education platform created by '
        "world's top professors",
  );

  const PageContent.second()
      : this(
    image: MediaRes.casualMeditation,
    title: 'Brand a fun atmosphere',
    description: 'This is the first online education platform created by '
        "world's top professors",
  );

  const PageContent.third()
      : this(
    image: MediaRes.casualLife,
    title: '',
    description: 'This is the first online education platform created by '
        "world's top professors",
  );

  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [image, title, description];
}

import 'package:flutter/cupertino.dart';
import 'package:kobo/core/enums/question_type.dart';

extension QuestionTypeExtensions on QuestionType {
  bool get isMedia => const {
    QuestionType.image,
    QuestionType.audio,
    QuestionType.video,
    QuestionType.file,
  }.contains(this);

  bool get isFullDate => const {
    QuestionType.start,
    QuestionType.end,
    QuestionType.datetime,
  }.contains(this);

  bool get isSelection => const {
    QuestionType.selectOne,
    QuestionType.selectOneFromFile,
    QuestionType.selectMultiple,
    QuestionType.selectMultipleFromFile,
    QuestionType.rank,
  }.contains(this);

  bool get isGroupOrRepeat => const {
    QuestionType.beginGroup,
    QuestionType.endGroup,
    QuestionType.beginRepeat,
    QuestionType.endRepeat,
  }.contains(this);

  bool get isMultiChoice => const {
    QuestionType.selectMultiple,
    QuestionType.selectMultipleFromFile,
    QuestionType.rank,
  }.contains(this);
}

extension QuestionTypeParsing on String {
  QuestionType toQuestionType() {
    switch (this) {
      case 'audit':
        return QuestionType.audit;
      case 'start':
        return QuestionType.start;
      case 'end':
        return QuestionType.end;
      case 'today':
        return QuestionType.today;
      case 'deviceid':
        return QuestionType.deviceid;
      case 'phonenumber':
        return QuestionType.phonenumber;
      case 'username':
        return QuestionType.username;
      case 'begin_group':
        return QuestionType.beginGroup;
      case 'end_group':
        return QuestionType.endGroup;
      case 'integer':
        return QuestionType.integer;
      case 'decimal':
        return QuestionType.decimal;
      case 'range':
        return QuestionType.range;
      case 'text':
        return QuestionType.text;
      case 'select_one':
        return QuestionType.selectOne;
      case 'select_multiple':
        return QuestionType.selectMultiple;
      case 'select_one_from_file':
        return QuestionType.selectOneFromFile;
      case 'select_multiple_from_file':
        return QuestionType.selectMultipleFromFile;
      case 'note':
        return QuestionType.note;
      case 'geopoint':
        return QuestionType.geopoint;
      case 'geotrace':
        return QuestionType.geotrace;
      case 'geoshape':
        return QuestionType.geoshape;
      case 'date':
        return QuestionType.date;
      case 'time':
        return QuestionType.time;
      case 'datetime':
        return QuestionType.datetime;
      case 'image':
        return QuestionType.image;
      case 'audio':
        return QuestionType.audio;
      case 'background-audio':
        return QuestionType.backgroundAudio;
      case 'video':
        return QuestionType.video;
      case 'file':
        return QuestionType.file;
      case 'barcode':
        return QuestionType.barcode;
      case 'calculate':
        return QuestionType.calculate;
      case 'email':
        return QuestionType.email;
      case 'xml-external':
        return QuestionType.xmlExternal;
      case 'acknowledge':
        return QuestionType.acknowledge;
      case 'hidden':
        return QuestionType.hidden;
      case 'begin_repeat':
        return QuestionType.beginRepeat;
      case 'end_repeat':
        return QuestionType.endRepeat;
      case 'rank':
        return QuestionType.rank;

      default:
        debugPrint('Unknown question type: $this');
        return QuestionType.unknown;
      // throw UnsupportedError('Unknown question type: $this');
    }
  }
}

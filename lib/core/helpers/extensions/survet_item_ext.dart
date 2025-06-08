import 'package:flutter/material.dart';
import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/shared/models/survey_item.dart';

extension SurveyItemExtension on SurveyItem {
  IconData getIcon() {
    final qt = type;

    switch (qt) {
      case QuestionType.unknown:
        return Icons.question_mark;
      case QuestionType.start:
        return Icons.arrow_forward_ios;
      case QuestionType.end:
        return Icons.arrow_back_ios;
      case QuestionType.deviceid:
        return Icons.fingerprint;
      case QuestionType.today:
        return Icons.calendar_today;
      case QuestionType.username:
        return Icons.person;
      case QuestionType.phonenumber:
        return Icons.phone;
      case QuestionType.audit:
        return Icons.content_paste_search;
      case QuestionType.date:
        return Icons.calendar_today;
      case QuestionType.time:
        return Icons.access_time;
      case QuestionType.datetime:
        return Icons.date_range;
      case QuestionType.text:
        return Icons.text_fields;
      case QuestionType.integer:
        return Icons.exposure_zero;
      case QuestionType.decimal:
        return Icons.trending_flat;
      case QuestionType.selectOne:
        return Icons.radio_button_checked;
      case QuestionType.selectMultiple:
        return Icons.check_box;
      case QuestionType.geopoint:
        return Icons.location_on;
      case QuestionType.image:
        return Icons.image;
      case QuestionType.calculate:
        return Icons.calculate;
      case QuestionType.note:
        return Icons.note;
      case QuestionType.beginGroup:
        return Icons.arrow_forward_ios;
      case QuestionType.endGroup:
        return Icons.arrow_back_ios;
      case QuestionType.backgroundAudio:
        return Icons.mic;
      case QuestionType.audio:
        return Icons.mic_none;
      case QuestionType.video:
        return Icons.video_call;
      case QuestionType.geotrace:
        return Icons.gesture;
      case QuestionType.geoshape:
        return Icons.map;
      case QuestionType.barcode:
        return Icons.qr_code_scanner;
      case QuestionType.acknowledge:
        return Icons.handshake;
      case QuestionType.hidden:
        return Icons.visibility_off;
      case QuestionType.file:
        return Icons.attach_file;
      case QuestionType.range:
        return Icons.linear_scale;
      case QuestionType.xmlExternal:
        return Icons.code;
      case QuestionType.selectOneFromFile:
        return Icons.radio_button_checked;
      case QuestionType.selectMultipleFromFile:
        return Icons.check_box;
      case QuestionType.email:
        return Icons.email;
      case QuestionType.beginRepeat:
        return Icons.login;
      case QuestionType.endRepeat:
        return Icons.logout;
      case QuestionType.rank:
        return Icons.thumbs_up_down;
      // default:
      //   return Icons.question_mark;
    }
  }
}

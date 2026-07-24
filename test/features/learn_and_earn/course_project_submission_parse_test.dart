import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_project_submission.dart';

/// Mirrors the private normalization in LearnAndEarnDataSource so we can verify
/// the real `/project/submissions` payload (flat rows with a nested assessment)
/// parses into CourseProjectSubmissionResult.
CourseProjectSubmissionResult? parseItem(Map<String, dynamic> item) {
  if (item.containsKey('submission')) {
    return CourseProjectSubmissionResult.fromJson(item);
  }
  return CourseProjectSubmissionResult.fromJson({
    'submission': item,
    'assessment': item['assessment'],
  });
}

void main() {
  test('parses a flat submissions list into scored results', () {
    final list = (jsonDecode(_sample) as List)
        .cast<Map<String, dynamic>>()
        .map(parseItem)
        .whereType<CourseProjectSubmissionResult>()
        .toList();

    expect(list, hasLength(2));

    // Latest by submittedAt.
    final latest = list.reduce((a, b) {
      final ka = a.submission.submittedAt ?? a.submission.createdAt;
      final kb = b.submission.submittedAt ?? b.submission.createdAt;
      return kb.isAfter(ka) ? b : a;
    });

    expect(latest.submission.id, 'd83f1415-f43b-4798-945a-b058df07d5fe');
    expect(latest.submission.submissionType, 'TEXT');
    expect(latest.assessment, isNotNull);
    expect(latest.assessment!.score, 100);
    expect(latest.assessment!.passed, isTrue);
    expect(latest.assessment!.strengths, isNotEmpty);
    expect(latest.assessment!.rawResponse, isNotNull);
  });

  test('parses a DRAFT row (empty textContent, link in linkUrl)', () {
    final list = (jsonDecode(_draftSample) as List)
        .cast<Map<String, dynamic>>()
        .map(parseItem)
        .whereType<CourseProjectSubmissionResult>()
        .toList();

    final drafts = list
        .where((r) => r.submission.status.toUpperCase() == 'DRAFT')
        .toList();
    expect(drafts, hasLength(1));

    final draft = drafts.single.submission;
    expect(draft.id, '8cc007f3-a37d-4b8f-afa0-adbe1023b9fd');
    expect(drafts.single.assessment, isNull);
    expect(draft.submittedAt, isNull);
    expect(draft.textContent, isEmpty);
    expect(draft.linkUrl, contains('docs.google.com'));

    // The submit form prefills typed fields from textContent, falling back to
    // linkUrl when textContent is empty (as it is for this draft).
    final prefill = (draft.textContent?.isNotEmpty ?? false)
        ? draft.textContent
        : draft.linkUrl;
    expect(prefill, draft.linkUrl);
  });
}

const _draftSample = '''
[
  {
    "id": "8cc007f3-a37d-4b8f-afa0-adbe1023b9fd",
    "createdAt": "2026-07-24T17:15:09.979Z",
    "updatedAt": "2026-07-24T17:15:09.979Z",
    "deletedAt": null,
    "userId": "c9b3bf9b-ff3e-4006-9843-94708bfdf96f",
    "courseProjectId": "8d20b8d5-4d2a-469a-a208-98269414c93f",
    "submissionType": "TEXT",
    "status": "DRAFT",
    "textContent": "",
    "fileUrl": null,
    "fileId": null,
    "linkUrl": "https://docs.google.com/document/d/1D1mchw6D0on_eb7ihI4TgVdZ88Cwg7s6WPiPGaKeuSY/edit?usp=sharing",
    "submittedAt": null,
    "assessment": null
  }
]
''';

const _sample = '''
[
  {
    "id": "d83f1415-f43b-4798-945a-b058df07d5fe",
    "createdAt": "2026-07-21T21:19:03.363Z",
    "updatedAt": "2026-07-21T21:19:03.363Z",
    "deletedAt": null,
    "userId": "f9920f80-2b3b-4f99-82b4-fc801fcb02db",
    "courseProjectId": "8d20b8d5-4d2a-469a-a208-98269414c93f",
    "submissionType": "TEXT",
    "status": "SUBMITTED",
    "textContent": "sample",
    "fileUrl": null,
    "fileId": null,
    "linkUrl": null,
    "submittedAt": "2026-07-21T21:19:03.278Z",
    "assessment": {
      "id": "d2177a79-d935-4db4-9317-1da7c6ef2c42",
      "createdAt": "2026-07-21T21:19:10.526Z",
      "updatedAt": "2026-07-21T21:19:10.526Z",
      "deletedAt": null,
      "submissionId": "d83f1415-f43b-4798-945a-b058df07d5fe",
      "status": "COMPLETED",
      "score": 100,
      "passed": true,
      "strengths": ["a", "b"],
      "weaknesses": [],
      "recommendations": ["c"],
      "rawResponse": {"score": 100, "passed": true},
      "errorMessage": null
    }
  },
  {
    "id": "dd26e677-57b5-4419-816d-d4a6626ebf4c",
    "createdAt": "2026-07-21T21:12:35.140Z",
    "updatedAt": "2026-07-21T21:12:35.140Z",
    "deletedAt": null,
    "userId": "f9920f80-2b3b-4f99-82b4-fc801fcb02db",
    "courseProjectId": "8d20b8d5-4d2a-469a-a208-98269414c93f",
    "submissionType": "TEXT",
    "status": "SUBMITTED",
    "textContent": "sample 2",
    "fileUrl": null,
    "fileId": null,
    "linkUrl": null,
    "submittedAt": "2026-07-21T21:12:35.054Z",
    "assessment": {
      "id": "0820432d-e399-4f3a-b54f-07e749aef9f4",
      "createdAt": "2026-07-21T21:12:43.141Z",
      "updatedAt": "2026-07-21T21:12:43.141Z",
      "deletedAt": null,
      "submissionId": "dd26e677-57b5-4419-816d-d4a6626ebf4c",
      "status": "COMPLETED",
      "score": 98,
      "passed": true,
      "strengths": ["x"],
      "weaknesses": ["y"],
      "recommendations": ["z"],
      "rawResponse": {"score": 98, "passed": true},
      "errorMessage": null
    }
  }
]
''';

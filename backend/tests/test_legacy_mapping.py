from pathlib import Path
import sys

sys.path.append(str(Path(__file__).resolve().parents[1]))

from app.services.progress_service import ProgressService


def test_legacy_entries_mapping():
    payload = {
        'onboardingRatio': 1.0,
        'belajarRatio': 0.5,
        'quizRatio': 0.2,
        'gameRatio': 0.0,
    }

    mapped = ProgressService._legacy_entries(payload)

    assert mapped[0]['lessonId'] == 'ONBOARDING'
    assert mapped[0]['score'] == 100
    assert mapped[0]['status'] == 'completed'
    assert mapped[1]['lessonId'] == 'BELAJAR'
    assert mapped[1]['score'] == 50

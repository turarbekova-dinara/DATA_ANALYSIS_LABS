import pandas as pd
from etl_pipeline import transform

def test_normal():
    df = pd.DataFrame({
    'email': ['a@test.com'],
    'name.first': ['Ali'],
    'name.last': ['Khan'],
    'dob.age': [25],
    'dob.date': ['2000-01-01'],
    'nat': ['KZ'],
    'gender': ['male']
})
    result = transform(df)
    assert result['age_group'].iloc[0] == 'Young Adult'

    assert result['email_domain'].iloc[0] == 'test.com'

def test_duplicates():
    df = pd.DataFrame({
        'email': ['a@test.com','a@test.com'],
        'name.first': ['Ali','Ali'],
        'name.last': ['Khan','Khan'],
        'dob.age': [25,25],
        'dob.date': ['2000-01-01','2000-01-01'],
        'nat': ['KZ','KZ'],
        'gender': ['male','male']
    })

    result = transform(df)
    assert len(result) == 1

def test_missing_email():
    df = pd.DataFrame({
        'email': [None],
        'name.first': ['Ali'],
        'name.last': ['Khan'],
        'dob.age': [25],
        'dob.date': ['2000-01-01'],
        'nat': ['KZ'],
        'gender': ['male']
})
    result = transform(df)
    assert result.empty

def test_empty():
    df = pd.DataFrame()
    result = transform(df)
    assert result.empty

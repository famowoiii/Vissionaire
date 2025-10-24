"""
Main entry point for DB Management API.
Run with: uvicorn main:app --host 0.0.0.0 --port 8005
"""
from examples.db_management.app import app

__all__ = ['app']

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8005)

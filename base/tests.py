from django.test import TestCase
from .models import Task
#from django.contrib.auth import get_user_model


User = get_user_model()

# Create your tests here.
class TaskModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='testuser', password='12345')
        self.task = Task.objects.create(
            user=self.user,
            title='Test Task',
            description='This is a test task.',
            completed=False
        )

    def test_task_creation(self):
        self.assertEqual(self.task.title, 'Test Task')
        self.assertEqual(self.task.description, 'This is a test task.')
        self.assertFalse(self.task.completed)
        self.assertEqual(str(self.task), 'Test Task')


from channels.generic.websocket import AsyncJsonWebsocketConsumer

from .models import ChatMessage


class ChatConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        self.user = self.scope["user"]
        self.room_name = self.scope["url_route"]["kwargs"]["room_name"]
        self.room_group_name = f"chat_{self.room_name}"

        if self.user.is_authenticated:
            await self.channel_layer.group_add(self.room_group_name, self.channel_name)
            await self.accept()
        else:
            await self.close()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def receive_json(self, content, **kwargs):
        message = content["message"]
        await ChatMessage.objects.acreate(
            message=message, room_name=self.room_name, posted_by=self.user
        )
        await self.channel_layer.group_send(
            self.room_group_name, {"type": "chat_message", "message": message}
        )

    async def chat_message(self, event):
        message = event["message"]
        await self.send_json({"message": message})

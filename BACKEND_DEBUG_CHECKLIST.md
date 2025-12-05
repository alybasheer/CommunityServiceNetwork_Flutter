# Backend Chat System - Debug Checklist

## Issue Summary
Frontend is working correctly but messages disappear because **backend API returns empty messages array** even after sending via socket.

**Current Status:**
```
✅ Frontend: Messages sent via socket
✅ Socket.io: Backend receives 'send_message' event
❌ Database: No messages found when API queries
❌ API: Returns `messages: []` even after sending
```

---

## Backend Debug Checklist

### 1. Socket Message Handler
**Location:** Your `socket.on('send_message')` handler

**Check:**
- [ ] Is the handler actually being triggered? Add `console.log()` at start
- [ ] Is it creating a Message document in MongoDB?
- [ ] Is it saving with `await message.save()`?
- [ ] Are `senderId` and `receiverId` being set correctly?
- [ ] Is timestamp being set to current time?

**Should look like:**
```javascript
socket.on('send_message', async (data) => {
  console.log('📨 Socket received send_message:', data);
  
  const message = new Message({
    senderId: data.senderId,
    receiverId: data.receiverId,
    content: data.content,
    timestamp: new Date(),
    isRead: false
  });
  
  await message.save(); // ← CRITICAL: Is this happening?
  console.log('✅ Message saved to DB:', message._id);
  
  // Broadcast to receiver
  socket.emit('receive_message', message);
});
```

### 2. API Endpoint - Get Conversation History
**Endpoint:** `GET /chat/conversation/:otherUserId?limit=50`

**Current Response (BROKEN):**
```json
{
  "success": true,
  "data": {
    "userId": "6931e4f061889ca3259f5c0b",
    "otherUserId": "692334954cae68e1a488fef2",
    "messageCount": 0,
    "messages": []
  }
}
```

**Check:**
- [ ] Is the query finding messages where sender=currentUser AND receiver=otherUser?
- [ ] Is the query also checking receiver=currentUser AND sender=otherUser?
- [ ] Is it sorting by timestamp?
- [ ] Is it limiting to correct number?

**Query should be:**
```javascript
const messages = await Message.find({
  $or: [
    { senderId: userId, receiverId: otherUserId },
    { senderId: otherUserId, receiverId: userId }
  ]
})
.sort({ timestamp: 1 })
.limit(limit);
```

### 3. MongoDB Message Schema
**Check:**
- [ ] Do all message documents have `senderId`?
- [ ] Do all message documents have `receiverId`?
- [ ] Are the IDs stored as `ObjectId` or `String`?
- [ ] Are timestamps being saved?

**Verify in MongoDB:**
```javascript
db.messages.findOne({}) // Check structure
db.messages.find({ senderId: "6931e4f061889ca3259f5c0b" }).count() // Any messages?
```

### 4. Test Steps

#### Step 1: Send Test Message via Socket
```javascript
// In your socket test tool (Postman, etc)
socket.emit('send_message', {
  senderId: "6931e4f061889ca3259f5c0b",
  receiverId: "692334954cae68e1a488fef2",
  content: "Test message"
});

// Check server logs - should see socket handler log
```

#### Step 2: Check Database Directly
```javascript
// In MongoDB shell or Compass
db.messages.find({
  senderId: "6931e4f061889ca3259f5c0b"
}).pretty()

// Should show saved messages
```

#### Step 3: Call API Directly
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "http://localhost:3000/chat/conversation/692334954cae68e1a488fef2?limit=50"

# Should return messages array with items
```

#### Step 4: Check Order
- If database has messages ✅ but API returns empty ❌
  - Query logic is wrong
- If API returns correct messages ✅ but frontend shows empty ❌
  - Frontend issue (but we've verified this works)
- If socket handler not logging ❌
  - Socket event not reaching backend

---

## Common Backend Issues

| Issue | Symptom | Fix |
|-------|---------|-----|
| Socket handler not saving | Messages sent but can't retrieve | Add `await message.save()` |
| Wrong user IDs | Saving but with wrong IDs | Verify user ID format (String vs ObjectId) |
| Query filtering wrong users | Query too broad/narrow | Use `$or` for bidirectional search |
| No timestamp | Old messages can't sort | Add `timestamp: new Date()` |
| Mixed user ID formats | Some messages save, some don't | Ensure consistent ID type throughout |
| Broadcast after save fails | Messages saved but not sent | Verify socket is connected after save |

---

## What Frontend is Sending

**Socket Event:**
```dart
socket.emit('send_message', {
  'receiverId': receiverId,
  'content': content
});
```

**Note:** Frontend sends `receiverId` and `content` only.  
Backend MUST add `senderId` from authenticated session!

**API Call:**
```dart
GET /chat/conversation/692334954cae68e1a488fef2?limit=50
Header: Authorization: Bearer TOKEN
```

**Expected Response (from your logs):**
```json
{
  "success": true,
  "data": {
    "userId": "6931e4f061889ca3259f5c0b",
    "otherUserId": "692334954cae68e1a488fef2",
    "messageCount": 15,
    "messages": [
      {
        "_id": "msg_123",
        "senderId": "6931e4f061889ca3259f5c0b",
        "receiverId": "692334954cae68e1a488fef2",
        "content": "Hello",
        "timestamp": "2025-12-06T10:30:00Z",
        "isRead": false
      },
      ...
    ]
  }
}
```

---

## Backend Logs to Enable

Add these logs to verify flow:

### Socket Handler
```javascript
// 1. Message received
console.log('📨 Socket send_message:', { senderId: socket.userId, data });

// 2. Before save
console.log('💾 Saving message...', message);

// 3. After save
console.log('✅ Message saved:', message._id);

// 4. Broadcasting
console.log('📡 Broadcasting to receiver:', receiverId);
```

### API Handler
```javascript
// 1. Request received
console.log('🔍 Fetching messages for:', { userId, otherUserId, limit });

// 2. Query result
console.log('📊 Query returned:', messages.length, 'messages');

// 3. Response sent
console.log('📤 Returning:', { messageCount: messages.length });
```

---

## Network Check (Frontend View)

In browser DevTools Network tab when fetching history:

**Request:**
```
GET /chat/conversation/692334954cae68e1a488fef2?limit=50
Authorization: Bearer eyJhbGc...
```

**Response should show:**
```json
{
  "success": true,
  "data": {
    "messageCount": 15,
    "messages": [...]
  }
}
```

If `messageCount: 0` → **Backend issue**

---

## TLDR - Quick Fix

If messages are being sent but not stored, add this to your backend socket handler:

```javascript
socket.on('send_message', async (data) => {
  try {
    const message = new Message({
      senderId: socket.userId,           // From auth
      receiverId: data.receiverId,       // From client
      content: data.content,             // From client
      timestamp: new Date(),             // Current time
      isRead: false
    });
    
    await message.save();  // ← MUST persist to DB
    
    // Emit to receiver
    socket.to(data.receiverId).emit('receive_message', message.toObject());
    
  } catch (error) {
    console.error('❌ Error saving message:', error);
  }
});
```

---

## Contact Points

**Frontend is correctly:**
- ✅ Sending via socket with `receiverId` and `content`
- ✅ Getting auth token and sending to API
- ✅ Calling endpoint: `GET /chat/conversation/{otherUserId}?limit=50`
- ✅ Parsing response correctly

**Backend MUST:**
1. Receive socket message ← Check logs
2. Save to database ← Check MongoDB
3. Return via API ← Check response format

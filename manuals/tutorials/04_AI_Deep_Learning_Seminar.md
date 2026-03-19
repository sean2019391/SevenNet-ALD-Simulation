# AI and Deep Learning Seminar — Code Examples

This document contains code examples from an introductory AI/deep learning seminar, progressing from basic neural networks to a GPT-style transformer language model.

---

## 1. Two-Layer Neural Network

A basic feedforward neural network with one hidden layer, sigmoid activation, softmax output, and numerical gradient computation.

```python
import sys, os
import numpy as np
sys.path.append(os.pardir)
from common.functions import *
from common.gradient import numerical_gradient

class TwoLayerNet:
    def __init__(self, input_size, hidden_size, output_size, weight_init_std=0.01):
        self.params = {}
        self.params['W1'] = weight_init_std * np.random.randn(input_size, hidden_size)
        self.params['b1'] = np.zeros(hidden_size)
        self.params['W2'] = weight_init_std * np.random.randn(hidden_size, output_size)
        self.params['b2'] = np.zeros(output_size)

    def predict(self, x):
        W1, W2 = self.params['W1'], self.params['W2']
        b1, b2 = self.params['b1'], self.params['b2']
        a1 = np.dot(x, W1) + b1
        z1 = sigmoid(a1)
        a2 = np.dot(z1, W2) + b2
        y = softmax(a2)
        return y

    def loss(self, x, t):
        y = self.predict(x)

    def accuracy(self, x, t):
        y = self.predict(x)
        y = np.argmax(y, axis=1)
        t = np.argmax(t, axis=1)
        accuracy = np.sum(y == t) / float(x.shape[0])
        return accuracy

    def numerical_gradient(self, x, t):
        loss_W = lambda W: self.loss(x, t)
        grads = {}
        grads['W1'] = numerical_gradient(loss_W, self.params['W1'])
        grads['b1'] = numerical_gradient(loss_W, self.params['b1'])
        grads['W2'] = numerical_gradient(loss_W, self.params['W2'])
        grads['b2'] = numerical_gradient(loss_W, self.params['b2'])
        return grads
```

---

## 2. Mini-Batch Learning (MNIST Digit Classification)

Trains the two-layer network on the MNIST dataset using stochastic gradient descent.

```python
import numpy as np
from dataset.mnist import load_mnist
from two_layer_net import TwoLayerNet

(x_train, t_train), (x_test, t_test) = load_mnist(normalize=True, one_hot_label=True)

train_loss_list = []
train_acc_list = []
test_acc_list = []

# Hyperparameters
iters_num = 10000
train_size = x_train.shape[0]
batch_size = 100
learning_rate = 0.1
network = TwoLayerNet(input_size=784, hidden_size=50, output_size=10)
iter_per_epoch = max(train_size / batch_size, 1)

for i in range(iters_num):
    # Sample a mini-batch
    batch_mask = np.random.choice(train_size, batch_size)
    x_batch = x_train[batch_mask]
    t_batch = t_train[batch_mask]

    # Compute gradients and update parameters
    grad = network.gradient(x_batch, t_batch)
    for key in ('W1', 'b1', 'W2', 'b2'):
        network.params[key] -= learning_rate * grad[key]

    loss = network.loss(x_batch, t_batch)
    train_loss_list.append(loss)

    if i % iter_per_epoch == 0:
        train_acc = network.accuracy(x_train, t_train)
        test_acc = network.accuracy(x_test, t_test)
        train_acc_list.append(train_acc)
        test_acc_list.append(test_acc)
        print(f"train acc, test acc | {train_acc}, {test_acc}")
```

---

## 3. Simple Multimodal Chatbot (Ollama + LLaVA)

Uses Ollama's LLaVA model to analyze images via a simple API call:

```python
import ollama

res = ollama.chat(
    model='llava',
    messages=[{
        'role': 'user',
        'content': 'identify this image',
        'images': ['/path/to/image.jpg']
    }]
)
print(res['message']['content'])
```

---

## 4. GPT-Style Transformer Language Model

A complete implementation of a causal transformer language model using PyTorch.

### Architecture

| Component | Description |
|-----------|-------------|
| `Head` | Single self-attention head with causal (lower-triangular) masking |
| `MultiHeadAttention` | Multiple attention heads in parallel, concatenated and projected |
| `FeedFoward` | Two-layer MLP with ReLU activation |
| `Block` | One transformer block: attention → layer norm → FFN → layer norm |
| `GPTLanguageModel` | Full model with token + position embeddings and autoregressive generation |

### Hyperparameters
```python
batch_size = 64        # Set via command line
block_size = 128       # Maximum context length
max_iters = 200
learning_rate = 3e-4
n_embd = 384           # Embedding dimension
n_head = 1             # Number of attention heads
n_layer = 1            # Number of transformer blocks
dropout = 0.2
```

### Self-Attention Head
```python
class Head(nn.Module):
    def __init__(self, head_size):
        super().__init__()
        self.key = nn.Linear(n_embd, head_size, bias=False)
        self.query = nn.Linear(n_embd, head_size, bias=False)
        self.value = nn.Linear(n_embd, head_size, bias=False)
        self.register_buffer('tril', torch.tril(torch.ones(block_size, block_size)))
        self.dropout = nn.Dropout(dropout)

    def forward(self, x):
        B, T, C = x.shape
        k = self.key(x)       # (B, T, head_size)
        q = self.query(x)     # (B, T, head_size)
        # Scaled dot-product attention
        wei = q @ k.transpose(-2, -1) * k.shape[-1]**-0.5  # (B, T, T)
        wei = wei.masked_fill(self.tril[:T, :T] == 0, float('-inf'))  # Causal mask
        wei = F.softmax(wei, dim=-1)
        wei = self.dropout(wei)
        v = self.value(x)
        return wei @ v         # (B, T, head_size)
```

### Interactive Generation
```python
model = GPTLanguageModel(vocab_size)
with open('model-01.pkl', 'rb') as f:
    model = pickle.load(f)
m = model.to(device)

while True:
    prompt = input("Prompt:\n")
    context = torch.tensor(encode(prompt), dtype=torch.long, device=device)
    generated = decode(m.generate(context.unsqueeze(0), max_new_tokens=150)[0].tolist())
    print(f'Completion:\n{generated}')
```

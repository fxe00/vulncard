<template>
  <div :class="['info-box', borderClass]">
    <h4>
      <i :class="`fas ${box.icon}`"></i> {{ box.title }}
    </h4>
    <div v-if="typeof box.content === 'string'">
      <p v-html="formatContent(box.content)"></p>
    </div>
    <div v-else-if="isListContent(box.content)">
      <ul>
        <li v-for="(item, index) in box.content.items" :key="index" v-html="formatContent(item)"></li>
      </ul>
    </div>
    <div v-if="box.code_example" class="code-example">
      <pre><code v-html="highlightCode(box.code_example)"></code></pre>
    </div>
    <div v-if="box.content_after" v-html="formatContent(box.content_after)"></div>
    <div v-if="box.code_example_2" class="code-example">
      <pre><code v-html="highlightCode(box.code_example_2)"></code></pre>
    </div>
    <div v-if="box.content_list && isListContent(box.content_list)">
      <ul>
        <li v-for="(item, index) in box.content_list.items" :key="index" v-html="formatContent(item)"></li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: 'InfoBox',
  props: {
    box: {
      type: Object,
      required: true
    }
  },
  computed: {
    borderClass() {
      const colorMap = {
        blue: 'blue-border',
        green: 'green-border',
        purple: 'purple-border'
      }
      return this.box.border_color ? colorMap[this.box.border_color] || '' : ''
    }
  },
  methods: {
    isListContent(content) {
      return content && typeof content === 'object' && content.type === 'list' && Array.isArray(content.items)
    },
    formatContent(text) {
      if (!text) return ''
      // 将换行符转换为 <br>
      return text.replace(/\n/g, '<br>')
    },
    highlightCode(code) {
      if (!code) return ''
      // 简单的代码高亮：注释行
      return code
        .replace(/\/\/.*$/gm, '<span class="comment">$&</span>')
        .replace(/#.*$/gm, '<span class="comment">$&</span>')
    }
  }
}
</script>

<style scoped>
.info-box {
  background: #f8f9fa;
  border-radius: 10px;
  padding: 18px;
  margin-bottom: 20px;
  border-left: 5px solid #e74c3c;
}

.info-box.blue-border {
  border-left-color: #3498db;
}

.info-box.green-border {
  border-left-color: #27ae60;
}

.info-box.purple-border {
  border-left-color: #9b59b6;
}

.info-box h4 {
  color: #2c3e50;
  margin-bottom: 12px;
  font-size: 16px;
  display: flex;
  align-items: center;
}

.info-box h4 i {
  margin-right: 8px;
  font-size: 14px;
}

.info-box p,
.info-box li {
  font-size: 14px;
  line-height: 1.5;
  color: #555;
}

.info-box ul {
  padding-left: 20px;
  margin-bottom: 10px;
}

.info-box li {
  margin-bottom: 8px;
}

.code-example {
  background: #2c3e50;
  color: #ecf0f1;
  border-radius: 8px;
  padding: 15px;
  font-family: 'Courier New', monospace;
  font-size: 13px;
  overflow-x: auto;
  margin: 15px 0;
  border-left: 5px solid #3498db;
}

.code-example pre {
  margin: 0;
  white-space: pre-wrap;
  word-wrap: break-word;
}

.code-example code {
  font-family: 'Courier New', monospace;
}

.code-example :deep(.comment) {
  color: #7f8c8d;
  font-style: italic;
}
</style>


<template>
  <div :class="['info-box', getBorderClass(), { 'first-info-section': isFirst }]" :style="boxStyle">
    <h4>
      <i :class="`fas ${section.icon}`"></i> {{ section.title }}
    </h4>
    <div v-if="section.columns && section.columns.length > 0" class="content-columns" style="gap: 20px; margin-bottom: 0; margin-top: 15px;">
      <div
        v-for="(column, colIndex) in section.columns"
        :key="colIndex"
        class="content-column"
      >
        <p v-if="column.title" style="margin-bottom: 12px; font-weight: bold; color: #2c3e50; font-size: 15px;">
          {{ column.title }}
        </p>
        <div v-if="isListContent(column.content)">
          <ul style="margin-top: 0;">
            <li v-for="(item, index) in column.content.items" :key="index" v-html="formatContent(item)"></li>
          </ul>
        </div>
        <div v-else-if="typeof column.content === 'string'">
          <div v-html="formatContent(column.content)" style="margin-top: 0;"></div>
        </div>
        <div v-else-if="column.boxes === null" style="color: #e74c3c; font-size: 12px; margin-top: 5px; padding: 10px; background: #fff3cd; border-radius: 4px;">
          警告：数据格式错误，请重启后端服务以使用新的数据模型
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'InfoSection',
  props: {
    section: {
      type: Object,
      required: true
    },
    isFirst: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    boxStyle() {
      if (this.isFirst) {
        return { marginBottom: '25px' }
      }
      return { marginTop: '25px', marginBottom: '25px' }
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
    getBorderClass() {
      const colorMap = {
        blue: 'blue-border',
        green: 'green-border',
        purple: 'purple-border'
      }
      return this.section.border_color ? colorMap[this.section.border_color] || '' : ''
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

.content-columns {
  display: flex;
  gap: 30px;
  margin-bottom: 25px;
}

.content-column {
  flex: 1;
  min-width: 0;
}

.info-box ul {
  padding-left: 20px;
  margin-bottom: 10px;
  margin-top: 10px;
}

.info-box li {
  margin-bottom: 12px;
  font-size: 14px;
  line-height: 1.6;
  color: #555;
}

.info-box li a {
  color: #3498db;
  text-decoration: none;
  transition: color 0.3s;
  font-weight: 500;
}

.info-box li a:hover {
  color: #2980b9;
  text-decoration: underline;
}

.info-box li div {
  margin-top: 4px;
}

.info-box p {
  font-size: 14px;
  line-height: 1.5;
  color: #555;
  margin-bottom: 10px;
}

@media (max-width: 1024px) {
  .content-columns {
    flex-direction: column;
    gap: 20px;
  }
}
</style>


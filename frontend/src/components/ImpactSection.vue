<template>
  <div>
    <h4 :style="{ color: '#2c3e50', margin: '25px 0 15px', fontSize: '16px' }">
      <i :class="`fas ${section.icon}`"></i> {{ section.title }}
    </h4>
    <div class="vulnerability-impact">
      <div
        v-for="(item, index) in section.items"
        :key="index"
        :class="['impact-item', getColorClass(item.color)]"
      >
        <div class="impact-icon">
          <i :class="`fas ${item.icon}`"></i>
        </div>
        <div class="impact-title">{{ item.title }}</div>
        <div class="impact-desc">{{ item.description }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ImpactSection',
  props: {
    section: {
      type: Object,
      required: true
    }
  },
  methods: {
    getColorClass(color) {
      const colorMap = {
        red: '',
        blue: 'blue-top',
        green: 'green-top',
        purple: 'purple-top'
      }
      return colorMap[color] || ''
    }
  }
}
</script>

<style scoped>
.vulnerability-impact {
  display: flex;
  gap: 15px;
  margin: 20px 0;
  flex-wrap: wrap;
}

.impact-item {
  flex: 1;
  background: #fff;
  border-radius: 8px;
  padding: 15px;
  text-align: center;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
  border-top: 4px solid #e74c3c;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.impact-item.blue-top {
  border-top-color: #3498db;
}

.impact-item.green-top {
  border-top-color: #27ae60;
}

.impact-item.purple-top {
  border-top-color: #9b59b6;
}

.impact-icon {
  font-size: 24px;
  margin-bottom: 10px;
  color: #e74c3c;
}

.impact-item.blue-top .impact-icon {
  color: #3498db;
}

.impact-item.green-top .impact-icon {
  color: #27ae60;
}

.impact-item.purple-top .impact-icon {
  color: #9b59b6;
}

.impact-title {
  font-weight: bold;
  margin-bottom: 8px;
  color: #2c3e50;
  font-size: 14px;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.impact-desc {
  font-size: 13px;
  color: #666;
  line-height: 1.5;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

@media (max-width: 1024px) {
  .vulnerability-impact {
    flex-wrap: wrap;
  }
  
  .impact-item {
    flex: 0 0 calc(50% - 8px);
    min-width: 200px;
  }
}

@media (max-width: 768px) {
  .vulnerability-impact {
    flex-direction: column;
    gap: 10px;
  }
  
  .impact-item {
    flex: 1 1 100%;
  }
}
</style>

